//
//  AstPrinter.swift
//  Slox
//
//  Created by Patrick Van den Bergh on 10/04/2022.
//

import Foundation

class AstPrinter: ExprVisitor {

    typealias T = String
    
    func visitBinaryExpr(_ expr: Binary) -> String {
        return parenthesize(expr.oper.lexeme, expr.left, expr.right)
    }
    
    func visitGroupingExpr(_ expr: Grouping) -> String {
        return parenthesize("group", expr.expression)
    }
    
    func visitLiteralExpr(_ expr: Literal) -> String {
        return String(expr.value.description)
    }
    
    func visitUnaryExpr(_ expr: Unary) -> String {
        return parenthesize(expr.oper.lexeme, expr.right)
    }
    
    func visitExpr(_ expr: Expr) -> String {
        return "Error"
    }
    
    func print(_ expr: Expr) -> String {
        return expr.accept(self)
    }
    
    func parenthesize(_ name: String, _ exprs: Expr...) -> String {
        var builder = ""
        builder += "(" + name
        for expr in exprs {
            builder += " "
            builder += expr.accept(self)
        }
        builder += ")"
        return builder
    }
}
