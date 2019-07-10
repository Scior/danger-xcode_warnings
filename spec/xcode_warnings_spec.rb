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

      it "Warns 2 lines filtered from the build log" do
        test_data = "/foo/hoge.swift:24:10: warning: instance method 'hoge()' took 112ms to type-check (limit: 100ms)"

        @xcode_warnings.analyze test_data

        expect(@dangerfile.status_report[:warnings]).to eq [
          "instance method 'hoge()' took 112ms to type-check (limit: 100ms)"
        ]
      end

      it "Doesn't warn with the clean build log" do
        @xcode_warnings.analyze ""

        expect(@dangerfile.status_report[:warnings]).to eq []
      end
    end
  end
end
