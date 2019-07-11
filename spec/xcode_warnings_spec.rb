require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerXcodeWarnings do
    it "should be a plugin" do
      expect(Danger::DangerXcodeWarnings.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @xcode_warnings = @dangerfile.xcode_warnings
      end

      it "Warns 4 lines filtered from the build log" do
        @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"

        expect(@dangerfile.status_report[:warnings]).to eq [
          "linking against a dylib which is not safe for use in application extensions: /hoge",
          "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
          "**/Users/fujino/iOS/ColorStock/ColorStock/Presentation/ViewModel/Implementation/ColorSelectorViewModel.swift#L75** instance method 'makeFlowLayout(with:)' took 104ms to type-check (limit: 100ms)",
          "**/Users/fujino/iOS/ColorStock/ColorStock/Data/Entity/Color.swift#L22** variable 'hoge' was never used; consider replacing with '_' or removing it"
        ]
        expect(@dangerfile.status_report[:messages]).to eq [
          "Detected 4 build-time warnings."
        ]
      end

      it "Doesn't warn with the clean build log" do
        @xcode_warnings.analyze_file "spec/fixtures/log_without_error"

        expect(@dangerfile.status_report[:warnings]).to eq []
        expect(@dangerfile.status_report[:messages]).to eq []
      end

      it "Couldn't find the file" do
        @xcode_warnings.analyze_file "spec/fixtures/hoge"
      end
    end
  end
end
