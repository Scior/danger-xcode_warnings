require_relative "./log_parser"
require_relative "./message_formatter"

module Danger
  # Parse the xcodebuild log file and convert warnings.
  # @example Parse and show xcodebuild warnings.
  #
  #          danger-xcode_warnings.analyze logfile
  #
  # @see  Scior/danger-xcode_warnings
  #
  class DangerXcodeWarnings < Plugin
    # Whether show build warnings or not.
    # @return [void]
    attr_accessor :show_build_warnings

    # Whether show linker warnings or not.
    # @return [void]
    attr_accessor :show_linker_warnings

    # rubocop:disable Lint/DuplicateMethods
    def show_build_warnings
      @show_build_warnings.nil? ? true : @show_build_warnings
    end

    def show_linker_warnings
      @show_linker_warnings || false
    end
    # rubocop:enable Lint/DuplicateMethods

    # Parses the log text from xcodebuild and show warnings.
    #
    # @param [String] log_text Raw build log text.
    # @param [Boolean] inline Whether leave comments inline or not.
    # @param [Boolean] sticky Whether use sticky flag or not.
    # @return [void]
    #
    def analyze(log_text, inline: false, sticky: true)
      parser = LogParser.new
      parser.show_build_warnings = show_build_warnings
      parser.show_linker_warnings = show_linker_warnings

      parsed = parser.parse(log_text)
      parsed.each do |warning|
        if inline
          warn(warning[:message], sticky: sticky, file: warning[:file], line: warning[:line])
        else
          warn MessageFormatter.new.format(warning)
        end
      end
      message "Detected #{parsed.count} build-time warnings." unless parsed.empty?
    end

    # Parses the log file from xcodebuild and show warnings.
    #
    # @param [String] file_path Path for the log file.
    # @param [Boolean] inline Whether leave comments inline or not.
    # @param [Boolean] sticky Whether use sticky flag or not.
    # @return [void]
    #
    def analyze_file(file_path, inline: false, sticky: true)
      File.open(file_path) do |f|
        puts "Opened #{file_path}"
        analyze(f.read, inline: inline, sticky: sticky)
      end
    rescue Errno::ENOENT, Errno::EACCES => e
      puts "Couldn't open the file: #{e}"
    end
  end
end
