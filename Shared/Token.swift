//
//  Token.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import Foundation

class Token {
    var type: TokenType
    var lexeme: String
    var literal: AnyObject?
    var line: Int
    
    init(_ type: TokenType, _ lexeme: String, _ literal: AnyObject?, _ line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
}

extension Token: CustomStringConvertible {
    var description: String {
        return "\(type.rawValue) \(lexeme) \(String(describing: literal)) \(line)"
    }
}
