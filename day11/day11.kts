import java.io.File
import java.util.Optional

// __REALLY__ UGLY KOTLIN CODE

class Monkey {
    var items: MutableList<Long>
    val operation: (Long) -> Long
    val test: (Long) -> Int
    val testPred: Long

    constructor(s: String) {
        val lines = s.split("\n")
        items = lines[1].split(": ")[1].split(", ").map { it.toLong() }.toMutableList()

        testPred = lines[3].split("divisible by ")[1].toLong()
        val testConsequent = lines[4].split("monkey ")[1].toInt()
        val testAlternative = lines[5].split("monkey ")[1].toInt()
        test = { i ->
            if (i % testPred == (0 as Number).toLong()) {
                testConsequent
            } else {
                testAlternative
            }
        }

        val operationString = lines[2].split("old ")[1]
        val operationNum = operationString.substring(2)
        operation = if (operationString[0] == '+') {
            if (operationNum == "old") {
                { i -> Math.addExact(i, i) }
//                { i -> (i % testPred + i % testPred) }
            } else {
                { i -> Math.addExact(i, operationNum.toLong()) }
//                { i -> (i % testPred + operationNum.toLong() % testPred) }
            }
        } else {
            if (operationNum == "old") {
                { i -> Math.multiplyExact(i, i) }
//                { i -> (i % testPred * i % testPred) }
            } else {
                { i -> Math.multiplyExact(i, operationNum.toLong()) }
//                { i -> (i % testPred * operationNum.toLong() % testPred) }
            }
        }
    }

    fun turn(f: (Long) -> Long): Optional<Pair<Long, Int>> {
        if (items.isEmpty()) return Optional.empty()
        var worryLevel = operation(items.removeFirst())
        worryLevel = f(worryLevel)
        val recipient = test(worryLevel)
        return Optional.of(Pair(worryLevel, recipient))
    }
}

fun readInput(filename: String): List<Monkey> {
    return File(filename).readText().trim().split("\n\n").map { Monkey(it) }
}

fun part1(monkeys: MutableList<Monkey>): Int {
    var results = MutableList<Int>(monkeys.size) { index -> 0 }

    repeat(20) {
        for (j in 0..monkeys.size - 1) {
            var p = monkeys[j].turn({ i -> i / 3 });
            while (p.isPresent()) {
                val (item, recipient) = p.get()
//                println("passed " + item + " to " + recipient)
                monkeys[recipient].items.add(item)
                results[j] += 1
                p = monkeys[j].turn({ i -> i / 3 });
            }
        }
    }

    results.sortDescending()
    return results[0] * results[1]
}

fun part2(monkeys: MutableList<Monkey>): Long {
    var results = MutableList<Long>(monkeys.size) { index -> 0 }
    val multiple = monkeys.map { it.testPred }.reduce { acc, l -> Math.multiplyExact(acc, l) }

    repeat(10000) {
        for (j in 0..monkeys.size - 1) {
            var p = monkeys[j].turn({ i -> i });
            while (p.isPresent()) {
                val (item, recipient) = p.get()
                // println("passed " + item + " to " + recipient)
                monkeys[recipient].items.add(item % multiple)
                results.set(j, results.get(j) + 1)
                p = monkeys[j].turn({ i -> i });
            }
        }
    }

//    println(results)
    results.sortDescending()
    return results[0] * results[1]
}

val input = readInput("day11.in")
var input1 = mutableListOf<Monkey>().apply { addAll(input) }
var input2 = mutableListOf<Monkey>().apply { addAll(input) }
println(part1(input1))
println(part2(input2))