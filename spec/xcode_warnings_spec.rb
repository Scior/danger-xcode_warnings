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

      it "Warns 3 lines filtered from the build log" do
        @xcode_warnings.analyze_file "spec/fixtures/log_with_3_errors"

        expect(@dangerfile.status_report[:warnings]).to eq [
          "initializer 'init(r:g:b:)' took 177ms to type-check (limit: 100ms)",
          "instance method 'makeFlowLayout(with:)' took 104ms to type-check (limit: 100ms)",
          "variable 'hoge' was never used; consider replacing with '_' or removing it"
        ]
      end

      it "Doesn't warn with the clean build log" do
        @xcode_warnings.analyze_file "spec/fixtures/log_without_error"

        expect(@dangerfile.status_report[:warnings]).to eq []
      end
    end
  end
end
