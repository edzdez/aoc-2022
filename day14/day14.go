package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Pair[T, U any] struct {
	First  T
	Second U
}

const (
	Rock int = iota
	Sand
	SandSource
)

func check(e error) {
	if e != nil {
		log.Fatal(e)
	}
}

func shiftAndInsert(res map[Pair[int, int]]int, x *int, y *int, newX int, newY int) {
	for *x != newX || *y != newY {
		if *x == newX {
			if *y < newY {
				*y++
			} else {
				*y--
			}
		} else if *y == newY {
			if *x < newX {
				*x++
			} else {
				*x--
			}
		}

		res[Pair[int, int]{*x, *y}] = Rock
	}
}

func parsePath(res map[Pair[int, int]]int, path string) {
	coords := strings.Split(path, " -> ")

	initialPosition := strings.Split(coords[0], ",")
	x, err := strconv.Atoi(initialPosition[0])
	check(err)
	y, err := strconv.Atoi(initialPosition[1])
	check(err)
	res[Pair[int, int]{x, y}] = Rock

	for _, coord := range coords[1:] {
		newPosition := strings.Split(coord, ",")
		newX, err := strconv.Atoi(newPosition[0])
		check(err)
		newY, err := strconv.Atoi(newPosition[1])
		check(err)

		shiftAndInsert(res, &x, &y, newX, newY)
	}
}

func readInput(filename string) map[Pair[int, int]]int {
	res := make(map[Pair[int, int]]int)
	// res[Pair[int, int]{500, 0}] = SandSource

	file, err := os.Open(filename)
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		parsePath(res, scanner.Text())
	}

	check(scanner.Err())

	return res
}

func findLowest(input map[Pair[int, int]]int) int {
	lowestPoint := 0

	for k := range input {
		if k.Second > lowestPoint {
			lowestPoint = k.Second
		}
	}

	return lowestPoint
}

func dropSand(input map[Pair[int, int]]int, lowestPoint int) bool {
	x, y := 500, 0

	for y <= lowestPoint {
		_, ok := input[Pair[int, int]{x, y + 1}]
		if !ok {
			y++
			continue
		}

		_, ok = input[Pair[int, int]{x - 1, y + 1}]
		if !ok {
			x--
			y++
			continue
		}

		_, ok = input[Pair[int, int]{x + 1, y + 1}]
		if !ok {
			x++
			y++
			continue
		}

		input[Pair[int, int]{x, y}] = Sand
		return true
	}

	return false
}

func part1(input map[Pair[int, int]]int) int {
	lowestPoint := findLowest(input)

	i := 0
	for dropSand(input, lowestPoint) {
		i += 1
	}

	return i
}

func dropSand2(input map[Pair[int, int]]int, lowestPoint int) bool {
	x, y := 500, 0

	for {
		if y+1 == lowestPoint {
			input[Pair[int, int]{x, y}] = Sand
			return true
		}

		_, ok := input[Pair[int, int]{x, y + 1}]
		if !ok {
			y++
			continue
		}

		_, ok = input[Pair[int, int]{x - 1, y + 1}]
		if !ok {
			x--
			y++
			continue
		}

		_, ok = input[Pair[int, int]{x + 1, y + 1}]
		if !ok {
			x++
			y++
			continue
		}

		if x == 500 && y == 0 {
			return false
		}

		input[Pair[int, int]{x, y}] = Sand
		return true
	}

	return false
}

func part2(input map[Pair[int, int]]int) int {
	lowestPoint := findLowest(input) + 2

	i := 0
	for dropSand2(input, lowestPoint) {
		i += 1
	}

	return i + 1
}

func main() {
	input := readInput("day14.in")
	fmt.Println(part1(input))
	input = readInput("day14.in")
	fmt.Println(part2(input))
}
