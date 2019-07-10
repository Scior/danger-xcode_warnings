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
    # Parses the log text from xcodebuild  and show warnings.
    # @return [void]
    #
    def analyze(log_text)
      LogParser.new.parse(log_text).each do |warning|
        warn(warning[:message], file: warning[:path], line: warning[:line])
      end
    end

    # Parses the log file from xcodebuild and show warnings.
    # @return [void]
    #
    def analyze_file(log_file)
      text = IO.read(log_file)
      analyze(text)
    end
  end
end
