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

      it "Warns 3 lines with default settings" do
        @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"

        expect(@dangerfile.status_report[:warnings]).to eq [
          "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
          "**/Users/fujino/iOS/ColorStock/ColorStock/Presentation/ViewModel/Implementation/ColorSelectorViewModel.swift#L75** instance method 'makeFlowLayout(with:)' took 104ms to type-check (limit: 100ms)",
          "**/Users/fujino/iOS/ColorStock/ColorStock/Data/Entity/Color.swift#L22** variable 'hoge' was never used; consider replacing with '_' or removing it"
        ]
        expect(@dangerfile.status_report[:messages]).to eq [
          "Detected 3 build-time warnings."
        ]
      end

      it "Warns 4 lines with all settings enabled" do
        @xcode_warnings.show_build_warnings = true
        @xcode_warnings.show_linker_warnings = true
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

      it "Doesn't warn lines with all settings disabled" do
        @xcode_warnings.show_build_warnings = false
        @xcode_warnings.show_linker_warnings = false
        @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"

        expect(@dangerfile.status_report[:warnings]).to eq []
        expect(@dangerfile.status_report[:messages]).to eq []
      end

      it "Show build timing summary" do
        @xcode_warnings.show_build_timing_summary = true
        @xcode_warnings.analyze_file "spec/fixtures/log_with_build_timing_summary"

        expect(@dangerfile.status_report[:warnings]).to eq []
        expect(@dangerfile.status_report[:messages]).to eq [
          "CompileStoryboard (2 tasks) | 10.000 seconds\n" \
          "CompileSwiftSources (1 task) | 2.000 seconds\n" \
          "Ld (1 task) | 0.000 seconds\n" \
          "LinkStoryboards (1 task) | 0.000 seconds\n" \
          "Total Build Time: **12.0s**"
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
