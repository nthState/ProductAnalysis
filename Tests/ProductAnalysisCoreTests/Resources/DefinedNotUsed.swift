//
//  Copyright 2022 nthState Ltd. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

  let key: AnalysisKeys.Level1.Level2A.Level2AStruct

  func run() {

  }

  func execute(event: Analyticable) {

  }

}
