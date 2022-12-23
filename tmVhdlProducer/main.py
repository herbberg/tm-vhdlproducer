import argparse
import glob
import logging
import os
import re
import subprocess
import sys
from typing import Dict

import tmEventSetup
import tmReporter

from .vhdlproducer import VhdlProducer
from .algodist import ProjectDir
from .algodist import distribute, constraint_t
from .algodist import MinModules, MaxModules
from .algodist import kExternals
from . import __version__

import urllib.request
import urllib.parse
import urllib.error
import stat
#from .toolbox import remove as tb_remove
#from .toolbox import make_executable as tb_make_executable

EXIT_SUCCESS: int = 0
EXIT_FAILURE: int = 1
LOGFILE: str = 'tm-vhdlproducer.log'
EXEC_REPORTER: str = 'tm-reporter'

SortingAsc: str = 'asc'
SortingDesc: str = 'desc'

DefaultNrModules: int = 6
DefaultRatio: float = 0.0
DefaultSorting: str = SortingDesc
DefaultOutputDir: str = os.getcwd()
from .algodist import DefaultConfigFile

ConstraintTypes: Dict[str, str] = {
    'ext': kExternals,
}
"""Mapping constraint types to esCondition types, provided for convenience."""

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------

def modules_t(value: str) -> int:
    """Validate number of modules input."""
    modules = int(value)
    if 1 <= modules <= MaxModules:
        return modules
    raise ValueError(modules)

def dist_t(value: str) -> int:
    """Validate firmware distribution number."""
    dist = int(value)
    if 1 <= dist:
        return dist
    raise ValueError(dist)

def ratio_t(value: str) -> float:
    """Validates shadow ratio input."""
    ratio = float(value)
    if .0 <= ratio <= 1.:
        return ratio
    raise ValueError(ratio)

def remove(filename):
    """Savely remove a directory, file or a symbolic link."""
    if os.path.isfile(filename):
        os.remove(filename)
    elif os.path.islink(filename):
        os.remove(filename)
    elif os.path.isdir(filename):
        shutil.rmtree(filename)

def make_executable(filename):
    """Set executable flag for file."""
    st = os.stat(filename)
    os.chmod(filename, st.st_mode | stat.S_IEXEC)

def download_file_from_url(url, filename):
    """Download files from URL."""
    # Remove existing file.
    remove(filename)
    # Download file
    logging.info("retrieving %s", url)
    urllib.request.urlretrieve(url, filename)
    make_executable(filename)

    with open(filename) as fp:
        d = fp.read()
    d = d.replace(', default=os.getlogin()', '')
    with open(filename, 'w') as fp:
        fp.write(d)

# -----------------------------------------------------------------------------
#  Command line parser
# -----------------------------------------------------------------------------

def parse_args():
    """Parse command line options."""
    parser = argparse.ArgumentParser(
        prog='tm-vhdlproducer',
        description="Trigger Menu VHDL Producer for uGT upgrade",
        epilog="Report bugs to <bernhard.arnold@cern.ch>"
    )
    parser.add_argument('menu',
        type=os.path.abspath,
        help="XML menu file to be loaded - from local or url"
    )
    parser.add_argument('--modules',
        metavar='<n>',
        type=modules_t,
        default=DefaultNrModules,
        help=f"number of modules ({MinModules}-{MaxModules}, default is {DefaultNrModules}))"
    )
    parser.add_argument('-d', '--dist',
        metavar='<n>',
        required=True,
        type=dist_t,
        help="firmware distribution number (starting with 1)"
    )
    parser.add_argument('--ratio',
        metavar='<f>',
        default=DefaultRatio,
        type=ratio_t,
        help=f"algorithm shadow ratio (0.0 < ratio <= 1.0, default is {DefaultRatio})"
    )
    parser.add_argument('--sorting',
        metavar='asc|desc',
        default=DefaultSorting,
        choices=(SortingAsc, SortingDesc),
        help=f"sort order for condition weights ({SortingAsc} or {SortingDesc}, default is {DefaultSorting})"
    )
    parser.add_argument('--config',
        metavar='<file>',
        default=DefaultConfigFile,
        type=os.path.abspath,
        help=f"JSON resource configuration file (default is {DefaultConfigFile})"
    )
    parser.add_argument('--constraint',
        metavar='<condition:modules>',
        action='append',
        type=constraint_t,
        help=f"limit condition type to a specific module, valid types are: {', '.join(ConstraintTypes)}"
    )
    parser.add_argument('-o', '--output',
        metavar='<dir>',
        default=DefaultOutputDir,
        type=os.path.abspath,
        help=f"directory to write VHDL producer output (default is {DefaultOutputDir})"
    )
    parser.add_argument('--dryrun',
        action='store_true',
        help="do not write any output to the file system"
    )
    parser.add_argument("--verbose",
        dest="verbose",
        action="store_true",
    )
    parser.add_argument('--version',
        action='version',
        version=f"L1 Trigger Menu VHDL producer version {__version__}"
    )
    return parser.parse_args()

# -----------------------------------------------------------------------------
#  Main routine
# -----------------------------------------------------------------------------

def main() -> int:
    """Main routine."""
    args = parse_args()

    # Setup console logging
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(format='%(levelname)s: %(message)s', level=level)

    logging.info("running VHDL producer...")

    logging.info("loading XML menu: %s", args.menu)
    if args.menu.find('https:/') == -1:
        https = False
        eventSetup = tmEventSetup.getTriggerMenu(args.menu)
        orig = os.path.dirname(os.path.realpath(args.menu))
        menu_filepath = args.menu
    else:
        https = True
        url = os.path.join('https://', args.menu.split('https:/')[1])
        xml_name = url.split('/')[-1]
        menu_filepath = os.path.join(os.getcwd(), xml_name)
        download_file_from_url(url, menu_filepath) # retrieve xml file from repo
        eventSetup = tmEventSetup.getTriggerMenu(menu_filepath)
        orig = os.path.dirname(menu_filepath)
    
    output_dir = os.path.join(args.output, f"{eventSetup.getName()}-d{args.dist}")

    # Prevent overwirting source menu
    dest = os.path.realpath(os.path.join(output_dir, 'xml'))
    if dest == orig:
        logging.error("%s is in %s directory which will be overwritten during the process", args.menu, dest)
        logging.error("     specified menu not in %s directory", dest)
        return EXIT_FAILURE

    if not args.dryrun:
        if os.path.isdir(output_dir):
            logging.error("directory `%s' already exists", output_dir)
            return EXIT_FAILURE
        else:
            os.makedirs(output_dir)

    if not args.dryrun:
        # Forward logs to file
        handler = logging.FileHandler(os.path.join(output_dir, LOGFILE), mode='a')
        handler.setFormatter(logging.Formatter(fmt='%(asctime)s %(levelname)s : %(message)s', datefmt='%Y-%m-%d %H:%M:%S'))
        handler.setLevel(level)
        logging.getLogger().addHandler(handler)

    # Distribute algorithms, set sort order (asc or desc)
    reverse_sorting = (args.sorting == 'desc')
    # Collect condition constraints
    constraints = {}
    if args.constraint:
        for k, v in args.constraint:
            constraints[ConstraintTypes[k]] = v
    # Run distibution
    collection = distribute(
        eventSetup=eventSetup,
        modules=args.modules,
        config=args.config,
        ratio=args.ratio,
        reverse_sorting=reverse_sorting,
        constraints=constraints
    )

    if args.dryrun:
        logging.info("skipped writing output (dryrun mode)")
    else:

        logging.info("writing VHDL modules...")
        template_dir = os.path.join(ProjectDir, 'templates', 'vhdl')
        producer = VhdlProducer(template_dir)
        producer.write(collection, output_dir)
        logging.info("writing updated XML file %s", args.menu)

        filename = producer.writeXmlMenu(menu_filepath, os.path.join(output_dir, 'xml'), args.dist) # TODO

        # Write menu documentation.
        logging.info("generating menu documentation...")
        doc_dir = os.path.join(output_dir, 'doc')

        logging.info("writing HTML documentation %s", filename)
        subprocess.check_call([EXEC_REPORTER, '-m', 'html', '-o', doc_dir, filename])

        logging.info("writing TWIKI page template %s", filename)
        subprocess.check_call([EXEC_REPORTER, '-m', 'twiki', '-o', doc_dir, filename])

        logging.info("patching filenames...")
        for filename in glob.glob(os.path.join(doc_dir, '*')):
            newname = re.sub(r'(.+)\.([a-z]+)$', rf'\1-d{args.dist}.\2', filename)
            logging.info("%s --> %s", filename, newname)
            os.rename(filename, newname)

    if https:
        logging.info("removed %s", menu_filepath)
        if os.path.exists(menu_filepath):
            os.remove(menu_filepath)
        else:
            logging.info("can not delete file  %s as it doesn't exists", menu_filepath)
            
    logging.info("done.")

    return EXIT_SUCCESS

if __name__ == '__main__':
    sys.exit(main())
