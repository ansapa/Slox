//
//  Lox.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import Foundation

class Lox {
    static let shared = Lox()
    private var output = ""
    private var hadError = false
    func run(code: String) -> String {
        output = ""
        let scanner = Scanner(code)
        let tokens = scanner.scanTokens()
        for token in tokens {
            output += "\(token)\n"
        }
        return output;
    }
    func error(_ line: Int, _ message: String) {
        report(line, "", message);
    }
    private func report(_ line: Int, _ location: String, _ message: String) {
        output += "[line \(line)] Error \(location): \(message)\n"
        hadError = true;
    }
}
