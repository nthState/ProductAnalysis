# ProductAnalysis

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
.package(url: "https://github.com/nthState/ProductAnalysis", branch: "main")
```

### Use a Plist

Add the following line to a `build phase script`:

```
${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalysis/run
```

Add a `ProductAnalysis.plist` to the root of your project

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
  <key>folderName</key>
  <string>Analysis</string>
</dict>
</plist>

```

### Use command line arguments

If you don't want to use a ProductAnalsis.plist file, you can pass arguments to `run` like so:

```
#${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalysis/run --folder-name "MyAnalysis" --enable-analysis --generate-source-code
```

## Running Tests

```
swift test --enable-code-coverage
```

Then to get a code-coverage report

```
/Library/Developer/CommandLineTools/usr/bin/llvm-cov \
  report ".build/x86_64-apple-macosx/debug/ProductAnalysisPackageTests.xctest/Contents/MacOS/ProductAnalysisPackageTests" \
  -instr-profile=".build/x86_64-apple-macosx/debug/codecov/default.profdata" \
  -use-color
```

---

## Logging

To view log events, open a new `Terminal` window and run:

```
log stream --level debug --predicate 'subsystem == "com.productAnalysis"'
```


---

## Getting Started with Development

To install dependencies run:

```
./scripts/new_developer.sh
```

---

## Appendix

Useful/Interesting links

- [ ] https://swiftrocks.com/code-generation-with-sourcekit
- [ ] https://nshipster.com/swift-gyb/


## Todo

- [ ] Localisation
- [ ] AnalysisReporter
- [ ] Versioning - Send bundle version as a start
- [ ] GitHub Action - Create Changelog
- [ ] GitHub Action - Run Tests on push
- [ ] Status Label
- [ ] Signed Commits only
- [ ] Return Code from CLI
- [ ] Should we move Configuration to be an extension
- [ ] Readme images
- [ ] Publish Package
