import ProductAnalyticsCore
import ArgumentParser

@main
public struct Main {
  
  @Option(help: "Access Token")
  var accessToken: String
  
  @Flag(help: "Treat warnings as Errors")
  var warningsAsErrors = false
  
  @Option(help: "JSON File Override")
  var jsonFilePath: String
  
  @Option(help: "Output Folder")
  var outputFolder: String
  
  @Option(help: "API Endpoint Override")
  var api: String
  
  @Option(help: "Optional Project Name")
  var projectName: String?
  
  public static func main() async {
    //print(Foo().text)
    let x = Test()
    x.doIt()
    
    do {
      let foo = try await x.fetch()
    } catch let error {
      print("has error")
      print(error.localizedDescription)
    }
    
  }
}
