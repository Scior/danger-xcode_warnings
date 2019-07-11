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

  # Parses the log text into hashes that represents warnings.
  #
  # @param [String] text The text to parse.
  # @return [Array] Array of `Warning`.
  #
  def parse(text)
    warning_texts = text.each_line.select { |s| s.include?(KEYWORD_WARNING) }.uniq
    warning_texts.map! { |s| parse_warning_text(s) }.compact
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
