import ProductAnalyticsCore
import ArgumentParser

@main
public struct Main {
  
  @Flag(help: "Treat warnings as errors")
  var warningsAsErrors = false
  
  @Option(help: "path to json")
  var jsonPath: String
  
  public static func main() {
    //print(Foo().text)
    let x = Test()
    x.doIt()
  }
}
