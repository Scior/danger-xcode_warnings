#
# Parser for the xcodebuild log.
#
class LogParser
  # The keyword for detecing warnings.
  KEYWORD_WARNING = " warning: ".freeze

  # Parses the log text into hashes that represents warnings.
  # @param [String] text The text to parse.
  # @return [Array] Array of hash that represents warnings
  #
  def parse(text)
    warning_texts = text.each_line.select { |s| s.include?(KEYWORD_WARNING) }.uniq
    warning_texts.map! { |s| parse_warning_text(s) }
  end

  private

  def parse_warning_text(text)
    puts text
    position, message = text.split(KEYWORD_WARNING)
    path, line, _column = position.split(":")

    {
      path: path,
      line: line,
      message: message.chomp
    }
  end
end
