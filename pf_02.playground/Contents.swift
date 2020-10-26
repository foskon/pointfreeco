func compute(_ x: Int) -> Int {
    x * x + 1
}

compute(2)
compute(2)
compute(2)

assertEqual(5, compute(2))
assertEqual(6, compute(2))
assertEqual(5, compute(3))


func computeWithEffect(_ x: Int) -> Int {
    let computation = x * x + 1
    print("Computed \(computation)")
    return computation
}

computeWithEffect(2)

assertEqual(5, computeWithEffect(2))

[2, 10].map(compute).map(compute)
[2, 10].map(compute >>> compute)

__

[2, 10].map(computeWithEffect).map(computeWithEffect)
[2, 10].map(computeWithEffect >>> computeWithEffect)

__
// Taking care of side effects

func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let computation = x * x + 1
    return (computation, ["Computed \(computation)"])
}

computeAndPrint(2)

assertEqual(
    (5, ["Computed 5"]),
    computeAndPrint(2)
)

assertEqual(
    (3, ["Computed 5"]),
    computeAndPrint(2)
)
assertEqual(
    (5, ["Computed 6"]),
    computeAndPrint(2)
)


2 |> compute >>> compute    // working
2 |> computeWithEffect >>> computeWithEffect    // working

// computeAndPrint >>> computeAndPrint  // not working. output of computeAndPrint is a tupple, but input is an Int

func compose<A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> (A) -> (C, [String]) {
    {
        let (b, str1) = f($0)
        let (c, str2) = g(b)
        return (c, str1 + str2)
    }
}

2 |> compose(computeAndPrint, computeAndPrint)  // solved

2 |> compose(compose(computeAndPrint, computeAndPrint), computeAndPrint)    // but very difficult to read
2 |> compose(computeAndPrint, compose(computeAndPrint, computeAndPrint))

// a problem with parentesis is solved with an infix operator

precedencegroup EffectfulComposition {
    associativity: left
    higherThan: FordwardApplication
    lowerThan: FordwardComposition
}

infix operator >=>: EffectfulComposition

func >=> <A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> (A) -> (C, [String]) {
    {
        let (b, str1) = f($0)
        let (c, str2) = g(b)
        return (c, str1 + str2)
    }
}

// Now it is easy to read
2
    |> computeAndPrint
    >=> computeAndPrint
    >=> computeAndPrint


2
    |> computeAndPrint
    >=> incr                // composition with side effect
    >>> computeAndPrint     // composition with NO side effect
    >=> square              // composition with side effect
    >>> computeAndPrint     // composition with NO side effect

// fish operator for Optionals
func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
) -> (A) -> C? {
    { f($0) == nil ?  nil :  g(f($0)!) }
}

String.init(utf8String:) >=> URL.init(string:)




func greetWithEffect(_ name: String) -> String {
    let seconds = Int(Date().timeIntervalSince1970) % 60
    return "Hello \(name). It's \(seconds) seconds past minute."
}

greetWithEffect("Carlos")   // very bad side effect


func greet(at date: Date, name: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name). It's \(seconds) seconds past minute."
}

greet(at: Date(), name: "Carlos")   // extract side effect

assertEqual(
    "Hello Carlos. It's 15 seconds past minute.",
    greet(at: Date.init(timeIntervalSince1970: 15), name: "Carlos")
)

// seems nice but composition is broken again

greetWithEffect     // (String) -> String, composable

func uppercased(_ string: String) -> String { string.uppercased() }

"Carlos" |> greetWithEffect >>> uppercased
"Carlos" |> uppercased >>> greetWithEffect

//greet               // (Date, String) -> String, no composable

//"Carlos" |> greet >>> uppercased
//"Carlos" |> uppercased >>> greet


func greet(at date: Date) -> (String) -> String {
    {
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \($0). It's \(seconds) seconds past minute."
    }
}

"Carlos" |> greet(at: Date()) >>> uppercased
"Carlos" |> uppercased >>> greet(at: Date())
