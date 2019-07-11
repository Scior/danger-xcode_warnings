#
# Formatter for parsed warnings.
#
class MessageFormatter
  # Format an item to text for Danger.
  #
  # @param [Warning] An item to format.
  # @return [String] Formatted text.
  #
  def format(item)
    file = item[:file]
    line = item[:line]
    message = item[:message]
    if file.nil? || line.nil?
      message
    else
      "**#{file}#L#{line}** #{message}"
    end
  end
end
