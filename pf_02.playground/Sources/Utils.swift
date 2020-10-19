import XCTest

@_exported import Foundation


// Pipe Fordward
//
precedencegroup FordwardApplication {
    associativity: left
}
infix operator |>: FordwardApplication
public func |> <A, B>(a: A, f: (A) -> B) -> B { f(a) }


// Fordward Composition
//
precedencegroup FordwardComposition {
    associativity: left
    higherThan: FordwardApplication
}
infix operator >>>: FordwardComposition
public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ( (A) -> C ) { { g(f($0)) } }


// Assert Equal
//
@discardableResult
public func assertEqual<A: Equatable>(_ lhs: A, _ rhs: A) -> String { lhs == rhs ? "✅" : "❌" }

@discardableResult
public func assertEqual<A: Equatable, B: Equatable>(_ lhs: (A, B), _ rhs: (A, B)) -> String { lhs == rhs ? "✅" : "❌" }


// Separator
//
public var __: Void {
    print("--")
}
