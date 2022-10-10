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

Add the following line to a `build phase script`:

```
${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalytics/run
```

### Requirements

- [ ] An iOS/tvOS/macOS/iPadOS Project

---

## Logging

To view log events, open a new `Terminal` window and run:

```
log stream --level debug --predicate 'subsystem == "com.productanalytics"'
```

---

## Appendix

Useful/interesting links

- [] https://swiftrocks.com/code-generation-with-sourcekit
- [] https://nshipster.com/swift-gyb/
