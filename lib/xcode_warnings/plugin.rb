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
    # @param [String] log_text Raw build log text.
    # @return [void]
    #
    def analyze(log_text, sticky = true)
      parsed = LogParser.new.parse(log_text)
      parsed.each do |warning|
        warn(warning[:message], sticky: sticky, file: warning[:path], line: warning[:line])
      end
      message "Detected #{parsed.count} build-time warnings." unless parsed.empty?
    end

    # Parses the log file from xcodebuild and show warnings.
    # @param [String] file_path Path for the log file.
    # @return [void]
    #
    def analyze_file(file_path, sticky = true)
      File.open(file_path) do |f|
        puts "Opened #{file_path}"
        analyze(f.read, sticky: sticky)
      end
    rescue Errno::ENOENT, Errno::EACCES => e
      puts "Couldn't open the file: #{e}"
    end
  end
end
