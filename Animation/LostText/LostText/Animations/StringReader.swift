//
//  StringReader.swift
//  LostText
//
//  Created by Sergey on 05.10.2020.
//

import Foundation

class StringReader {
    private let lines: [String]
    private var lineNumber: Int = 0
    
    func readLine() -> String? {
        if lines.count > lineNumber {
            let result = lines[lineNumber]
            lineNumber += 1
            return result
        }
        return nil
    }
    
    init(_ text: String) {
        lines = text.split(separator: "\n").map { String($0) }
    }
}
