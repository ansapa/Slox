//
//  Parser.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 12/04/2022.
//

import Foundation

class Parser {
    func parse() -> Expr? {
        do {
            return try expression()
        } catch {
            return nil
        }
    }
    private class ParserError: Error {
    }
    let tokens: [Token]
    var current = 0
    init(_ tokens: [Token]) {
        self.tokens = tokens
    }
    private func expression() throws -> Expr {
        return try equality()
    }
    private func equality() throws -> Expr {
        var expr = try comparison()
        while (match(.BANG_EQUAL, .EQUAL_EQUAL)) {
            let oper = previous()
            let right = try comparison()
            expr = Binary(expr, oper, right)
        }
        return expr
    }
    private func comparison() throws -> Expr {
        var expr = try term()
        while (match(.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL)) {
            let oper = previous()
            let right = try term()
            expr = Binary(expr, oper, right)
        }
        return expr
    }
    private func term() throws -> Expr {
        var expr = try factor()
        while (match(.MINUS, .PLUS)) {
            let oper = previous()
            let right = try factor()
            expr = Binary(expr, oper, right)
        }
        return expr
    }
    private func factor() throws -> Expr {
        var expr = try unary()
        while (match(.SLASH, .STAR)) {
            let oper = previous()
            let right = try unary()
            expr = Binary(expr, oper, right)
        }
        return expr
    }
    private func unary() throws -> Expr {
        if (match(.BANG, .MINUS)) {
            let oper = previous()
            let right = try unary()
            return Unary(oper, right)
        }
        return try primary()
    }
    private func primary() throws -> Expr {
        if (match(.FALSE)) {
            return Literal(false as AnyObject)
        }
        if (match(.TRUE)) {
            return Literal(true as AnyObject)
        }
        if (match(.NIL)) {
            return Literal(nil)
        }
        if (match(.NUMBER, .STRING)) {
            return Literal(previous().literal as AnyObject)
        }
        if (match(.LEFT_PAREN)) {
            let expr = try expression()
            try consume(.RIGHT_PAREN, "Expect ')' after expression.")
            return Grouping(expr)
        }
        throw error(peek(), "Expect expression")
    }
    
    // MARK: Helpers
    private func match(_ types: TokenType...) -> Bool {
        for type in types {
            if (check(type)) {
                advance()
                return true
            }
        }
        return false;
    }
    private func check(_ type: TokenType) -> Bool {
        if (isAtEnd()) {
            return false
        }
        return peek().type == type
    }
    private func advance() -> Token {
        if (!isAtEnd()) {
            current += 1
        }
        return previous()
    }
    private func isAtEnd() -> Bool {
        return peek().type == .EOF
    }
    
    private func peek() -> Token {
        return tokens[current]
    }
    
    private func previous() -> Token {
        return tokens[current - 1]
    }
    
    private func consume(_ type: TokenType, _ message: String) throws -> Token {
        if ((check(type))) {
            return advance()
        }
        throw error(peek(), message)
    }
    
    private func error(_ token: Token, _ message: String) -> ParserError {
        Lox.shared.error(token, message)
        return ParserError()
    }
    
    private func synchronize() {
        advance()
        while (!isAtEnd()) {
            if (previous().type == .SEMICOLON) {
                return
            }
            switch (peek().type) {
            case .CLASS, .FUN, .VAR, .FOR, .IF, .WHILE, .PRINT, .RETURN:
                return
            default:
                break
            }
            advance()
        }
    }
}
