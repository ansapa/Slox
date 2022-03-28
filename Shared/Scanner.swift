//
//  Scanner.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import Foundation

class Scanner {
    let keywords: [String: TokenType] = [
        "and": .AND,
        "class": .CLASS,
        "else": .ELSE,
        "false": .FALSE,
        "for": .FOR,
        "fun": .FUN,
        "if": .IF,
        "nil": .NIL,
        "or": .OR,
        "print": .PRINT,
        "return": .RETURN,
        "super": .SUPER,
        "this": .THIS,
        "var": .VAR,
        "while": .WHILE
    ]
    let source: String
    var tokens = [Token]()
    private var start = 0
    private var current = 0
    private var line = 1
    init(_ source: String) {
        self.source = source
    }
    func scanTokens() -> [Token] {
        while (!isAtEnd()) {
            // We are at the beginning of the next lexeme.
            start = current
            scanToken()
        }
        tokens.append(Token(.EOF, "", nil, line))
        return tokens
    }
    private func isAtEnd() -> Bool {
        return current >= source.count
    }
    private func scanToken() {
        let c = advance()
        switch (c) {
        case "(":
            addToken(.LEFT_PAREN)
        case ")":
            addToken(.RIGHT_PAREN)
        case "{":
            addToken(.LEFT_BRACE)
        case "}":
            addToken(.RIGHT_BRACE)
        case ",":
            addToken(.COMMA)
        case ".":
            addToken(.DOT)
        case "-":
            addToken(.MINUS)
        case "+":
            addToken(.PLUS)
        case ";":
            addToken(.SEMICOLON)
        case "*":
            addToken(.STAR)
        case "!":
            addToken(match("=") ? .BANG_EQUAL : .BANG)
        case "=":
            addToken(match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<":
            addToken(match("=") ? .LESS_EQUAL : .LESS)
        case ">":
            addToken(match("=") ? .GREATER_EQUAL : .EQUAL)
        case "/":
            if (match("/")) {
                // A comment goes until the end of the line.
                while (peek() != "\n" && !isAtEnd()) {
                    advance()
                }
            } else {
                addToken(.SLASH)
            }
        case " ", "\r", "\t":
            // Ignore whitespace
            break
        case "\n":
            line += 1
        case "\"":
            string()
        default:
            if (isDigit(c)) {
                number()
            } else if (isAlpha(c)) {
                identifier()
            }
            else {
                Lox.shared.error(line, "Unexpected character.")
            }
        }
    }
    // MARK: Helpers
    @discardableResult private func advance() -> Character {
        let index = source.index(source.startIndex, offsetBy: current)
        current += 1
        return source[index]
    }
    private func addToken(_ type: TokenType) {
        addToken(type, nil)
    }
    private func addToken(_ type: TokenType, _ literal: AnyObject?) {
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let text = String(source[startIndex..<endIndex])
        tokens.append(Token(type, text, literal, line))
    }
    private func match(_ expected: Character) -> Bool {
        if (isAtEnd()) {
            return false;
        }
        let index = source.index(source.startIndex, offsetBy: current)
        if source[index] != expected {
            return false
        }
        current += 1
        return true
    }
    private func peek() -> Character {
        if (isAtEnd()) {
            return "\0"
        }
        let index = source.index(source.startIndex, offsetBy: current)
        return source[index]
    }
    private func peekNext() -> Character {
        if (current + 1 >= source.count) {
            return "\0"
        }
        let index = source.index(source.startIndex, offsetBy: current + 1)
        return source[index]
    }
    private func string() {
        while (peek() != "\"" && !isAtEnd()) {
            if (peek() == "\n") {
                line += 1
            }
            advance()
        }
        if (isAtEnd()) {
            Lox.shared.error(line, "Unterminated string.")
            return
        }
        // The closing ".
        advance()
        // Trim the surrounding quotes
        let startIndex = source.index(source.startIndex, offsetBy: start + 1)
        let endIndex = source.index(source.startIndex, offsetBy: current - 1)
        let value = String(source[startIndex..<endIndex])
        addToken(.STRING, value as AnyObject?)
    }
    private func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }
    private func isAlpha(_ c: Character) -> Bool {
        return (c >= "a" && c <= "z") ||
               (c >= "A" && c <= "Z") ||
               c == "_"
    }
    private func isAlphaNumeric(_ c: Character) -> Bool {
        return isAlpha(c) || isDigit(c)
    }
    private func number() {
        while (isDigit(peek())) {
            advance()
        }
        // Look for a fractional part.
        if (peek() == "." && isDigit(peekNext())) {
            // Consume the "."
            advance()
            while (isDigit(peek())) {
                advance()
            }
        }
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let value = String(source[startIndex..<endIndex])
        addToken(.NUMBER, Double(value) as AnyObject?)
    }
    private func identifier() {
        while (isAlphaNumeric(peek())) {
            advance()
        }
        let startIndex = source.index(source.startIndex, offsetBy: start)
        let endIndex = source.index(source.startIndex, offsetBy: current)
        let text = String(source[startIndex..<endIndex])
        if let keyword = keywords[text] {
            addToken(keyword)
        } else {
            addToken(.IDENTIFIER)
        }
    }
}
