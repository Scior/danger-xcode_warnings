require_relative "./log_parser"
require_relative "./log_parser_xcpretty"
require_relative "./message_formatter"

module Danger
  # Parse the xcodebuild log file and convert warnings.
  # @example Parse and show xcodebuild warnings.
  #
  #          danger-xcode_warnings.analyze_file 'logfile'
  #
  # @see  Scior/danger-xcode_warnings
  #
  class DangerXcodeWarnings < Plugin
    # Whether show build warnings or not.
    # @return [void]
    attr_accessor :show_build_warnings

    # Whether show linker warnings or not. The default value is `false`.
    # @return [void]
    attr_accessor :show_linker_warnings

    # Whether show build timing summary or not. The default value is `false`.
    # @return [void]
    attr_accessor :show_build_timing_summary

    # Whether use xcpretty for formatting logs. The default value is `false`.
    # @return [void]
    attr_accessor :use_xcpretty

    # rubocop:disable Lint/DuplicateMethods

    def show_build_warnings
      @show_build_warnings.nil? ? true : @show_build_warnings
    end

    def show_linker_warnings
      @show_linker_warnings || false
    end

    def show_build_timing_summary
      @show_build_timing_summary || false
    end

    def use_xcpretty
      @use_xcpretty || false
    end
    # rubocop:enable Lint/DuplicateMethods

    # Parses the log text from xcodebuild and show warnings.
    #
    # @param [String] log_text Raw build log text.
    # @param [Boolean] inline Whether leave comments inline or not.
    # @param [Boolean] sticky Whether use sticky flag or not.
    # @return [void]
    #
    def analyze(log_text, inline: true, sticky: true)
      if use_xcpretty
        parser = LogParserXCPretty.new
      else
        parser = LogParser.new
        parser.show_build_timing_summary = show_build_timing_summary
      end
      parser.show_build_warnings = show_build_warnings
      parser.show_linker_warnings = show_linker_warnings

      parsed = parser.parse_warnings(log_text)
      parsed.each do |warning|
        if inline
          warn(warning[:message], sticky: sticky, file: warning[:file], line: warning[:line])
        else
          warn MessageFormatter.new.format(warning)
        end
      end
      message "Detected #{parsed.count} build-time warnings." unless parsed.empty?
      message parser.parse_build_timing_summary(log_text)
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
