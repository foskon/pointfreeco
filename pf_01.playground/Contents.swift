
func incr(_ x: Int) -> Int { x + 1 }

incr(2)

func square(_ x: Int) -> Int { x * x }

square(incr(2))


// Pipe Fordward

precedencegroup FordwardApplication {
    associativity: left
}

infix operator |>: FordwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B { f(a) }

2 |> incr
2 |> incr |> square


// Fordward Composition

precedencegroup FordwardComposition {
    associativity: left
    higherThan: FordwardApplication
}

infix operator >>>: FordwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ( (A) -> C ) { { g(f($0)) } }

incr >>> square

2 |>
    incr >>> square

2 |> incr >>> square >>> String.init

// map over compositions is the compositions of the maps
[1, 2, 3]
    .map(incr >>> square)

[1, 2, 3]
    .map(incr)
    .map(square)
