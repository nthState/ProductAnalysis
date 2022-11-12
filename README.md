# ProductAnalysis

[![Swift Lint](https://github.com/nthState/ProductAnalysis/actions/workflows/lint.yml/badge.svg)](https://github.com/nthState/ProductAnalysis/actions/workflows/lint.yml)
[![Unit Tests](https://github.com/nthState/ProductAnalysis/actions/workflows/unit_tests.yml/badge.svg)](https://github.com/nthState/ProductAnalysis/actions/workflows/unit_tests.yml)
[![Update Changelog, Create Release](https://github.com/nthState/ProductAnalysis/actions/workflows/update_changelog_create_release.yml/badge.svg)](https://github.com/nthState/ProductAnalysis/actions/workflows/update_changelog_create_release.yml)

![Introduction](assets/Intro.svg)

## Introduction

A compile-time check to see if you've implemented everything required by the product team.

## Integrating into your Project

Add this Swift Package to your App:

```swift
.package(url: "https://github.com/nthState/ProductAnalysis", branch: "main")
```

### Add Build Phase

Add the following line to a `Build Phase Script`:

```bash
${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalysis/run
```

### Use a Plist

Add a `ProductAnalysis.plist` to the root of your project

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>warningsAsErrors</key>
  <false/>
  <key>duplicatesAsErrors</key>
  <false/>
  <key>enableAnalysis</key>
  <true/>
  <key>accessToken</key>
  <string>my_token</string>
  <key>enableReportAnalysisResults</key>
  <true/>
  <key>enableGenerateSourceCode</key>
  <true/>
  <key>folderName</key>
  <string>Analysis</string>
</dict>
</plist>

```

### Use command line arguments

If you don't want to use a `ProductAnalysis.plist` file, you can pass arguments to `run` like so:

```bash
#${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalysis/run --folder-name "MyAnalysis" --enable-analysis --enable-generate-source-code
```

## Development

### Getting Started with Development

To install dependencies run the following script, it installs Xcode Command line tools, Commitizen, Pre commit & Swiftlint

```bash
./scripts/new_developer.sh
```

### Running Tests

If you want to run unit tests, use the following script, this is also ran as a GitHub Action

```bash
swift test --enable-code-coverage
```

Then to get a code-coverage report (GitHub Action reports this too)

```bash
ARCH=$(uname -m)
/Library/Developer/CommandLineTools/usr/bin/llvm-cov \
  report ".build/${ARCH}-apple-macosx/debug/ProductAnalysisPackageTests.xctest/Contents/MacOS/ProductAnalysisPackageTests" \
  -instr-profile=".build/${ARCH}-apple-macosx/debug/codecov/default.profdata" \
  -use-color
```

## Logging

To view log events, open a new `Terminal` window and run:

```bash
log stream --level debug --predicate 'subsystem == "com.productAnalysis"'
```

## Deployment

### Creating a Release

To create a release, you need to add a tag, and push it.
GitHub Actions handle the rest.


```bash
git tag vx.x.x
```

Then push

```bash
git push origin vx.x.x   
```


## Appendix

Useful/Interesting links

- [ ] https://swiftrocks.com/code-generation-with-sourcekit

## Todo

- [ ] Localisation
- [ ] AnalysisReporter
- [ ] Versioning - Send bundle version as a start
- [ ] Signed Commits only with GitHub Action
- [ ] Service Tests
- [ ] Self-hosted runner