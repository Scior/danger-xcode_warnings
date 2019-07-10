require_relative "./log_parser"

module Danger
  # Parse the xcodebuild log file and convert warnings.
  # @example Parse and show xcodebuild warnings.
  #
  #          danger-xcode_warnings.analyze logfile
  #
  # @see  Scior/danger-xcode_warnings
  #
  class DangerXcodeWarnings < Plugin
    # Parses the log from xcodebuild and show warnings and errors.
    #
    def analyze(log_text)
      LogParser.parse(log_text).each do |warning|
        warn(warning[:message], file: warning[:path], line: warning[:line])
      end
    end
  end
end
