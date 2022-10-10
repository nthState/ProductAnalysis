# ProductAnalytics

A description of this package.




https://swiftrocks.com/code-generation-with-sourcekit
https://nshipster.com/swift-gyb/


Add the following line to a `build phase script`

```
${BUILD_DIR%Build/*}SourcePackages/checkouts/ProductAnalytics/run
```



To view log events, open a new `Terminal` window and run:
```
log stream --level debug --predicate 'subsystem == "com.productanalytics"'
```
