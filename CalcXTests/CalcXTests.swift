//
//  CalcXTests.swift
//  CalcXTests
//
//  Created by Calvin Andoh on 7/13/25.
//

import Testing
@testable import CalcX

struct CalculatorEngine {
    var equation: String = ""
    var result: String = ""

    mutating func input(_ value: String) {
        if !result.isEmpty { equation = ""; result = "" }
        equation.append(value)
    }
    mutating func clear() {
        equation = ""
        result = ""
    }
    mutating func delete() {
        if !equation.isEmpty { equation.removeLast() }
    }
    mutating func percent() {
        if let value = Double(equation) {
            result = String(value / 100)
        }
    }
    mutating func operation(_ op: String) {
        if !equation.isEmpty, let last = equation.last, "+-*/".contains(last) == false {
            equation.append(op)
        }
    }
    mutating func equals() {
        result = evaluate(equation)
    }
    func evaluate(_ expression: String) -> String {
        let exp = expression.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/")
        let expr = NSExpression(format: exp)
        if let value = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            return String(describing: value)
        }
        return "Error"
    }
}

struct CalcXTests {
    @Test func testInputAndClear() async throws {
        var engine = CalculatorEngine()
        engine.input("2")
        engine.input("+")
        engine.input("2")
        #expect(engine.equation == "2+2")
        engine.clear()
        #expect(engine.equation == "")
        #expect(engine.result == "")
    }

    @Test func testDelete() async throws {
        var engine = CalculatorEngine()
        engine.input("1")
        engine.input("2")
        engine.delete()
        #expect(engine.equation == "1")
        engine.delete()
        #expect(engine.equation == "")
        engine.delete()
        #expect(engine.equation == "")
    }

    @Test func testPercent() async throws {
        var engine = CalculatorEngine()
        engine.input("50")
        engine.percent()
        #expect(engine.result == "0.5")
    }

    @Test func testOperation() async throws {
        var engine = CalculatorEngine()
        engine.input("3")
        engine.operation("+")
        #expect(engine.equation == "3+")
        engine.operation("-")
        #expect(engine.equation == "3+") // should not add another op
        engine.input("2")
        engine.operation("-")
        #expect(engine.equation == "3+2-")
    }

    @Test func testEqualsSimple() async throws {
        var engine = CalculatorEngine()
        engine.input("2")
        engine.operation("+")
        engine.input("2")
        engine.equals()
        #expect(engine.result == "4")
    }

    @Test func testEqualsComplex() async throws {
        var engine = CalculatorEngine()
        engine.input("10")
        engine.operation("*")
        engine.input("5")
        engine.operation("-")
        engine.input("2")
        engine.equals()
        #expect(engine.result == "48")
    }

    @Test func testInvalidExpression() async throws {
        var engine = CalculatorEngine()
        engine.input("2")
        engine.operation("+")
        engine.equals()
        #expect(engine.result == "Error")
    }
}
