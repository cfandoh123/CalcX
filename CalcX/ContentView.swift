//
//  ContentView.swift
//  CalcX
//
//  Created by Calvin Andoh on 7/13/25.
//

import SwiftUI

struct CalculatorButton: Identifiable {
    let id = UUID()
    let title: String
    let background: Color
    let foreground: Color
    let action: CalculatorAction
}

enum CalculatorAction {
    case input(String)
    case clear
    case delete
    case percent
    case operation(String)
    case equals
    case none
}

struct ContentView: View {
    @State private var equation: String = ""
    @State private var result: String = ""
    @State private var isDarkMode: Bool = true

    private let buttonSpacing: CGFloat = 12
    private let buttonCornerRadius: CGFloat = 24

    private var buttons: [[CalculatorButton]] {
        let opColor = isDarkMode ? Color.gray.opacity(0.7) : Color.gray.opacity(0.2)
        let numColor = isDarkMode ? Color(.darkGray) : Color(.systemGray5)
        let actionColor = isDarkMode ? Color.green.opacity(0.8) : Color.green
        let textColor = isDarkMode ? Color.white : Color.black
        let opTextColor = isDarkMode ? Color.white : Color.black
        return [
            [
                CalculatorButton(title: "C", background: opColor, foreground: opTextColor, action: .clear),
                CalculatorButton(title: "Del", background: opColor, foreground: opTextColor, action: .delete),
                CalculatorButton(title: "%", background: opColor, foreground: opTextColor, action: .percent),
                CalculatorButton(title: "÷", background: opColor, foreground: opTextColor, action: .operation("/")),
            ],
            [
                CalculatorButton(title: "7", background: numColor, foreground: textColor, action: .input("7")),
                CalculatorButton(title: "8", background: numColor, foreground: textColor, action: .input("8")),
                CalculatorButton(title: "9", background: numColor, foreground: textColor, action: .input("9")),
                CalculatorButton(title: "×", background: opColor, foreground: opTextColor, action: .operation("*")),
            ],
            [
                CalculatorButton(title: "4", background: numColor, foreground: textColor, action: .input("4")),
                CalculatorButton(title: "5", background: numColor, foreground: textColor, action: .input("5")),
                CalculatorButton(title: "6", background: numColor, foreground: textColor, action: .input("6")),
                CalculatorButton(title: "-", background: opColor, foreground: opTextColor, action: .operation("-")),
            ],
            [
                CalculatorButton(title: "1", background: numColor, foreground: textColor, action: .input("1")),
                CalculatorButton(title: "2", background: numColor, foreground: textColor, action: .input("2")),
                CalculatorButton(title: "3", background: numColor, foreground: textColor, action: .input("3")),
                CalculatorButton(title: "+", background: opColor, foreground: opTextColor, action: .operation("+")),
            ],
            [
                CalculatorButton(title: "0", background: numColor, foreground: textColor, action: .input("0")),
                CalculatorButton(title: ".", background: numColor, foreground: textColor, action: .input(".")),
                CalculatorButton(title: "=", background: actionColor, foreground: Color.white, action: .equals),
            ]
        ]
    }

    var body: some View {
        ZStack {
            (isDarkMode ? Color(red: 48/255, green: 49/255, blue: 54/255) : Color(.systemGray6))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    ThemeToggle(isDarkMode: $isDarkMode)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Text(equation)
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 24)
                    Text(result)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 24)
                }
                .padding(.bottom, 32)
                VStack(spacing: buttonSpacing) {
                    ForEach(0..<buttons.count, id: \.self) { row in
                        HStack(spacing: buttonSpacing) {
                            ForEach(buttons[row]) { button in
                                Button(action: { handleAction(button.action) }) {
                                    Text(button.title)
                                        .font(.system(size: 24, weight: .medium, design: .rounded))
                                        .frame(width: button.title == "0" ? 120 : 60, height: 60)
                                        .background(button.background)
                                        .foregroundColor(button.foreground)
                                        .cornerRadius(buttonCornerRadius)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }

    private func handleAction(_ action: CalculatorAction) {
        switch action {
        case .input(let value):
            if result != "" { equation = ""; result = "" }
            equation.append(value)
        case .clear:
            equation = ""
            result = ""
        case .delete:
            if !equation.isEmpty { equation.removeLast() }
        case .percent:
            if let value = Double(equation) {
                result = String(value / 100)
            }
        case .operation(let op):
            if !equation.isEmpty, let last = equation.last, "+-*/".contains(last) == false {
                equation.append(op)
            }
        case .equals:
            result = evaluate(equation)
        case .none:
            break
        }
    }

    private func evaluate(_ expression: String) -> String {
        let exp = expression.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/")
        let expr = NSExpression(format: exp)
        if let value = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            return String(describing: value)
        }
        return "Error"
    }
}

struct ThemeToggle: View {
    @Binding var isDarkMode: Bool
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sun.max.fill")
                .foregroundColor(.yellow)
                .opacity(isDarkMode ? 0.3 : 1)
            ZStack {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 28)
                HStack {
                    Spacer(minLength: 0)
                    Circle()
                        .fill(isDarkMode ? Color(.systemGray) : Color(.systemGray6))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(isDarkMode ? .yellow : .orange)
                        )
                        .offset(x: isDarkMode ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: isDarkMode)
                }
                .frame(width: 44, height: 28)
            }
            .onTapGesture { isDarkMode.toggle() }
            Image(systemName: "moon.fill")
                .foregroundColor(.yellow)
                .opacity(isDarkMode ? 1 : 0.3)
        }
    }
}

#Preview {
    ContentView()
}
