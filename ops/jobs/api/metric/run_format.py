# -*- coding: utf-8 -*-

# Module imports.
import os

from tornado.options import define, options

import metrics_formatter as formatter

import utils



# Define command line options.
define("group",
       type=str,
       help="Name of metrics group (e.g. cmip5-1).")
define("input_format",
       type=str,
       default="pcmdi",
       help="Format of metrics input files (defaults to pcmdi).")
define("input_dir",
       type=str,
       help="Path to either a directory containing metrics files.")


def _main():
    """Main entry point.

    """
    options.parse_command_line()
    options.group = utils.parse_group_id(options.group)

    formatter.execute(options.group,
                      options.input_dir,
                      options.input_format)


# Main entry point.
if __name__ == '__main__':
    _main()
