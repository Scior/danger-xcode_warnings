require File.expand_path("spec_helper", __dir__)

# rubocop:disable Metrics/ModuleLength
module Danger
  describe Danger::DangerXcodeWarnings do
    it "should be a plugin" do
      expect(Danger::DangerXcodeWarnings.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @xcode_warnings = @dangerfile.xcode_warnings
      end

      context "with default settings" do
        before do
          @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"
        end

        it "warn 3 lines" do
          expect(@dangerfile.status_report[:warnings]).to eq [
            "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
            "**/Users/fujino/iOS/ColorStock/ColorStock/Presentation/ViewModel/Implementation/ColorSelectorViewModel.swift#L75** instance method 'makeFlowLayout(with:)' took 104ms to type-check (limit: 100ms)",
            "**/Users/fujino/iOS/ColorStock/ColorStock/Data/Entity/Color.swift#L22** variable 'hoge' was never used; consider replacing with '_' or removing it"
          ]
        end
        it "put a single message" do
          expect(@dangerfile.status_report[:messages]).to eq [
            "Detected 3 build-time warnings."
          ]
        end
      end

      context "enable showing build and linker warnings" do
        before do
          @xcode_warnings.show_build_warnings = true
          @xcode_warnings.show_linker_warnings = true
          @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"
        end

        it "warn 4 lines" do
          expect(@dangerfile.status_report[:warnings]).to eq [
            "linking against a dylib which is not safe for use in application extensions: /hoge",
            "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
            "**/Users/fujino/iOS/ColorStock/ColorStock/Presentation/ViewModel/Implementation/ColorSelectorViewModel.swift#L75** instance method 'makeFlowLayout(with:)' took 104ms to type-check (limit: 100ms)",
            "**/Users/fujino/iOS/ColorStock/ColorStock/Data/Entity/Color.swift#L22** variable 'hoge' was never used; consider replacing with '_' or removing it"
          ]
        end
        it "put a single message" do
          expect(@dangerfile.status_report[:messages]).to eq [
            "Detected 4 build-time warnings."
          ]
        end
      end

      context "disable all settings" do
        before do
          @xcode_warnings.show_build_warnings = false
          @xcode_warnings.show_linker_warnings = false
          @xcode_warnings.analyze_file "spec/fixtures/log_with_4_errors"
        end

        it "show no warnings" do
          expect(@dangerfile.status_report[:warnings]).to eq []
        end
        it "show no messages" do
          expect(@dangerfile.status_report[:messages]).to eq []
        end
      end

      context "enable showing build timing summary" do
        before do
          @xcode_warnings.show_build_timing_summary = true
          @xcode_warnings.analyze_file "spec/fixtures/log_with_build_timing_summary"
        end

        it "show no warnings" do
          expect(@dangerfile.status_report[:warnings]).to eq []
        end
        it "show build timing summary" do
          expect(@dangerfile.status_report[:messages]).to eq [
            "CompileStoryboard (2 tasks) | 10.000 seconds\n" \
            "CompileSwiftSources (1 task) | 2.000 seconds\n" \
            "Ld (1 task) | 0.000 seconds\n" \
            "LinkStoryboards (1 task) | 0.000 seconds\n" \
            "Total Build Time: **12.0s**"
          ]
        end
      end

      context "with the clean build log" do
        before do
          @xcode_warnings.analyze_file "spec/fixtures/log_without_error"
        end

        it "show no warnings" do
          expect(@dangerfile.status_report[:warnings]).to eq []
        end
        it "show no messages" do
          expect(@dangerfile.status_report[:messages]).to eq []
        end
      end

      context "file not found" do
        it "do nothing" do
          @xcode_warnings.analyze_file "spec/fixtures/hoge"
        end
      end

      context "use xcpretty log with default settings" do
        before do
          @xcode_warnings.use_xcpretty = true
          @xcode_warnings.analyze_file "spec/fixtures/log_xcpretty"
        end

        it "warn 2 lines" do
          expect(@dangerfile.status_report[:warnings]).to eq [
            "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)"
          ]
        end
        it "put a single message" do
          expect(@dangerfile.status_report[:messages]).to eq [
            "Detected 1 build-time warnings."
          ]
        end
      end

      context "use xcpretty log and enable linker warnings" do
        before do
          @xcode_warnings.use_xcpretty = true
          @xcode_warnings.show_linker_warnings = true
          @xcode_warnings.analyze_file "spec/fixtures/log_xcpretty"
        end

        it "warn 2 lines" do
          expect(@dangerfile.status_report[:warnings]).to eq [
            "**/Users/fujino/iOS/ColorStock/ColorStock/Utility/Extension/UIColor+.swift#L13** initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
            "linking against a dylib which is not safe for use in application extensions: /hoge"
          ]
        end
        it "put 2 messages" do
          expect(@dangerfile.status_report[:messages]).to eq [
            "Detected 2 build-time warnings."
          ]
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
