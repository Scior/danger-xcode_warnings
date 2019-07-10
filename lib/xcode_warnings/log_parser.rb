class LogParser
  SYMBOL_WARNING = " warning: ".freeze

  def parse(text)
    warning_texts = text.grep(SYMBOL_WARNING).uniq
    warning_texts.map(&:parse_warning_text)
  end

  def parse_warning_text(text)
    position, message = text.split(SYMBOL_WARNING)
    path, line, _column = position.split(":")

    {
      path: path,
      line: line,
      message: message
    }
  end
end
