# danger-xcode_warnings

[![version](https://img.shields.io/badge/version-0.1.2-blue.svg)](https://github.com/Scior/danger-xcode_warnings)
[![Build Status](https://travis-ci.org/Scior/danger-xcode_warnings.svg?branch=master)](https://travis-ci.org/Scior/danger-xcode_warnings)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Danger plugin to show warnings from xcodebuild.

![Sample](doc/sample.png)

## Installation

```sh
gem install danger-xcode_warnings
```

Or using Bundler,

```ruby
gem 'danger-xcode_warnings'
```

## Usage

Simply collect the log from `xcodebuild`,

```sh
xcodebuild clean build >> buildlog.log
```

and analyze on your `Dangerfile`.

```ruby
xcode_warnings.analyze_file 'buildlog.log'
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
