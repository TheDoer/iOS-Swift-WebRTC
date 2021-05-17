//
//  DebugPrint.swift
//  
//
//  Created by Adonis Rumbwere on 17/5/2021.
//  Copyright © 2021 Adonis Inc. All rights reserved.
//

import Foundation

public func dLog(_ object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
  #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    print("[\(className)] \(functionName) [#\(lineNumber)]| \(object)\n")
  #endif
}
