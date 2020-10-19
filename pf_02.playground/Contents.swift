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


func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let computation = x * x + 1
    return (computation, ["Computed \(computation)"])
}

__
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


2 |> compute >>> compute
2 |> computeWithEffect >>> computeWithEffect
