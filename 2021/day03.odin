package main

import "core:fmt"
import "core:strconv"
import "core:math"
import "core:strings"
import "core:testing"

import "utils"

BIT_COUNT :: uint(12)

TEST_INPUT :: `00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
`

main :: proc() {
    data := utils.read_day_input_to_integer_slice("03", 2)

    part1(data, BIT_COUNT)
    part2(data)
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    data: [dynamic]int
    for l in strings.split(TEST_INPUT, "\n") {
        n, _ := strconv.parse_int(l, 2)
        append(&data, n)
    }
    
    result := part1(data[:], 5)
    testing.expect_value(t, result, 198)
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    data: [dynamic]int
    for l in strings.split(TEST_INPUT, "\n") {
        n, _ := strconv.parse_int(l, 2)
        append(&data, n)
    }
    
    result := part2(data[:], 5)
    testing.expect_value(t, result, 230)
}

part1 :: proc(data: []int, bit_count: uint) -> uint {
    counter := make([]int, bit_count)
    get_bit :: proc(number: int, pos: uint) -> int {
        return (number >> pos) & 1
    }

    for n in data[:] {
        for bit_pos in 0..<bit_count {
            counter[bit_pos] += get_bit(n, bit_pos)
        }
    }
    fmt.println(counter)

    calc_gamma :: proc(counter: []int, data_count: int) -> (gamma: uint) {
        if counter[0] > data_count/2 {
            gamma += 1
        }

        for bit_pos in 1..<len(counter) {
            if counter[bit_pos] > data_count/2 {
                gamma += uint(math.pow(2, f64(bit_pos)))
            }
        }

        return
    }

    calc_epsilon :: proc(counter: []int, data_count: int) -> (epsilon: uint) {
        if counter[0] < data_count/2 {
            epsilon += 1
        }

        for bit_pos in 1..<len(counter) {
            if counter[bit_pos] < data_count/2 {
                epsilon += uint(math.pow(2, f64(bit_pos)))
            }
        }

        return
    }


    gamma := calc_gamma(counter[:], len(data))
    epislon := calc_epsilon(counter[:], len(data))

    fmt.println(gamma, epislon)

    fmt.println("DAY 3 PART 1 RESULT:", gamma * epislon)
    return gamma * epislon
}

part2 :: proc(data: []int) {

    fmt.println("DAY 3 PART 2 RESULT:", )
}
