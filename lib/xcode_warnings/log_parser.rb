#
# Parser for the xcodebuild log.
#
class LogParser
  # The keyword for detecing warnings.
  KEYWORD_WARNING = " warning: ".freeze

  # Struct represents warnings.
  Warning = Struct.new(:file, :line, :message)

  # Whether show build warnings or not.
  # @return [void]
  attr_accessor :show_build_warnings

  # Whether show linker warnings or not.
  # @return [void]
  attr_accessor :show_linker_warnings

  # Whether show build timing summary or not.
  # @return [void]
  attr_accessor :show_build_timing_summary

  # Parses the log text into array of Warnings.
  #
  # @param [String] text The text to parse.
  # @return [Array] Array of `Warning`.
  #
  def parse_warnings(text)
    warning_texts = text.each_line.select { |s| s.include?(KEYWORD_WARNING) }.uniq
    warning_texts.map! { |s| parse_warning_text(s) }.compact
  end

  # Parses the log text into a build timing summary message.
  #
  # @param [String] text The text to parse.
  # @return [String] Message of build timing summary.
  #
  def parse_build_timing_summary(text)
    return nil unless @show_build_timing_summary

    lines = text.lines(chomp: true)
    index = lines.index("Build Timing Summary")
    return nil if index.nil?

    lines[index + 1..-1].select { |s| s =~ /.+/ }.join("\n")
  end

  private

  def parse_warning_text(text)
    puts text
    position, message = text.split(KEYWORD_WARNING)
    if position.start_with?("ld")
      # Linker warning
      return nil unless @show_linker_warnings

      return Warning.new(nil, nil, message.chomp)
    end

    # Build warnings
    return nil unless @show_build_warnings

    path, line, _column = position.split(":")
    return nil if path.nil?

    Warning.new(path.gsub("#{Dir.pwd}/", ""), line, message.chomp)
  end
end
