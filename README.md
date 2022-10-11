# ProductAnalytics

---

## Steps

### Calculate

Download the JSON file, calculate what we should generate

### Generate

Take the output from the calculate step, and write the files

### Analyse

Based on the output from the calcuate step, and the source code on disk
Analyse what needs to be warned/errored


---

## Integrating into your Project

Add this Swift Package to your App:

```
.package(url: "https://github.com/nthState/ProductAnalytics", branch: "main")
```

Add the following line to a `build phase script`:

```
${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalytics/run
```

Add a `ProductAnalytics.plist` to the root of your project

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>warningsAsErrors</key>
  <false/>
  <key>enableAnalysis</key>
  <true/>
  <key>accessToken</key>
  <string>my_token</string>
  <key>reportAnalysisResults</key>
  <true/>
  <key>generateSourceCode</key>
  <true/>
</dict>
</plist>

```

## Running Tests

```
swift test --enable-code-coverage
```

Then to get a code-coverage report

```
/Library/Developer/CommandLineTools/usr/bin/llvm-cov \
  report ".build/x86_64-apple-macosx/debug/ProductAnalyticsPackageTests.xctest/Contents/MacOS/ProductAnalyticsPackageTests" \
  -instr-profile=".build/x86_64-apple-macosx/debug/codecov/default.profdata" \
  -use-color
```

---

## Logging

To view log events, open a new `Terminal` window and run:

```
log stream --level debug --predicate 'subsystem == "com.productanalytics"'
```

---

## Appendix

Useful/interesting links

- [ ] https://swiftrocks.com/code-generation-with-sourcekit
- [ ] https://nshipster.com/swift-gyb/
