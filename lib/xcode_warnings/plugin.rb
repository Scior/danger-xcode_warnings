module Danger
  # @example Ensure people are well warned about merging on Mondays
  #
  #          my_plugin.warn_on_mondays
  #
  # @see  Scior/danger-xcode_warnings
  #
  class DangerXcodeWarnings < Plugin

    # An attribute that you can read/write from your Dangerfile
    #
    # @return   [Array<String>]
    attr_accessor :my_attribute

    # A method that you can call from your Dangerfile
    # @return   [Array<String>]
    #
    def warn_on_mondays
      warn 'Trying to merge code on a Monday' if Date.today.wday == 1
    end
  end
end
