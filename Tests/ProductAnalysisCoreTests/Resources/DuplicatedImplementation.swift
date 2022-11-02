//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation

protocol Analyzable {
  
}

enum AnalysisKeys {
  enum Level1 {
    enum Level2A {
      struct Level2AStruct: Analyzable {
        
      }
    }
    enum Level2B {
      struct Level2BStruct: Analyzable {
        // Should not be initalized
      }
    }
  }
}

class SemiImplemented {
  
  private class Inside {
    
  }
  
  func run() {
    execute(event: AnalysisKeys.Level1.Level2A.Level2AStruct())
    
    // Duplicate event
    execute(event: AnalysisKeys.Level1.Level2A.Level2AStruct())
  }
  
  func execute(event: Analyticable) {
    
  }
  
}
