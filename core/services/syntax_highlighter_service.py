import logging
import time
from yavide_service import YavideService
from services.syntax_highlighter.syntax_highlighter import VimSyntaxHighlighter
from services.syntax_highlighter.tag_identifier import TagIdentifier
from common.yavide_utils import YavideUtils

class SyntaxHighlighter(YavideService):
    def __init__(self, server_queue, yavide_instance):
        YavideService.__init__(self, server_queue, yavide_instance)
        self.output_syntax_file = "/tmp/yavideSyntaxFile.vim"
        self.syntax_highlighter = VimSyntaxHighlighter(self.output_syntax_file)

    def run_impl(self, args):
        contents = str(args[0])
        original_filename = str(args[1])
        start = time.clock()
        self.syntax_highlighter.generate_vim_syntax_file(contents)
        end = time.clock()
        logging.info("Generating vim syntax for '{0}' took {1}.".format(original_filename, end-start))
        YavideUtils.call_vim_remote_function(self.yavide_instance, "Y_SrcCodeHighlighter_Apply('" + original_filename + "'" + ", '" + self.output_syntax_file + "')")

