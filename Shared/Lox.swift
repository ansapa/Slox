//
//  Lox.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import Foundation

class Lox {
    let unary: Unary
    let grouping: Grouping
    let expr: Binary
    static let shared = Lox()
    private var output = ""
    private var hadError = false
    init() {
        self.unary = Unary(Token(.MINUS, "-", nil, 1), Literal(123 as AnyObject))
        self.grouping = Grouping(Literal(45.67 as AnyObject))
        self.expr = Binary(unary, Token(.STAR, "*", nil, 1), grouping)
    }
    func run(code: String) -> String {
        output = ""
        let scanner = Scanner(code)
        let tokens = scanner.scanTokens()
        let parser = Parser(tokens)
        let expression = parser.parse()
        // Stop if there was a syntax error
        if (hadError) {
            return "hadError"
        }
        output = AstPrinter().print(expression!)
        return output;
    }
    func error(_ line: Int, _ message: String) {
        report(line, "", message);
    }
    private func report(_ line: Int, _ location: String, _ message: String) {
        output += "[line \(line)] Error \(location): \(message)\n"
        hadError = true;
    }
    func error(_ token: Token, _ message: String) {
        if (token.type == .EOF) {
            report(token.line, " at end", message)
        } else {
            report(token.line, " at '" + token.lexeme + "''", message)
        }
    }
}
