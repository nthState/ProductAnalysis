//
//  File.swift
//  
//
//  Created by Chris Davis on 12/10/2022.
//

import Foundation

func makeTempFolder(named: String) throws -> URL {
  
  let url = URL(string: NSTemporaryDirectory().appending(named))!
  
  var isDirectory: ObjCBool = false
  if !FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: &isDirectory) {
    try FileManager.default.createDirectory(atPath: url.absoluteString, withIntermediateDirectories: true)
  }
  
  return url
}
