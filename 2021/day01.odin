package main

import "core:fmt"
import "core:math"

import "utils"

main :: proc() {
    data := utils.read_day_input_to_integer_slice("01")

    part1(data)
    part2(data)
}

part1 :: proc(data: []int) {
    increase_counter := 0
    prev_measurement := data[0]
    for measurement in data[1:] {
        fmt.print(prev_measurement, "-->", measurement, ' ')
        if prev_measurement < measurement  {
            increase_counter += 1
            fmt.println("Increase")
        } else {
            fmt.println("Decrease")
        }

        prev_measurement = measurement
    }

    fmt.println("DAY 1 PART 1 RESULT:", increase_counter)
}

part2 :: proc(data: []int) {
    increase_counter := 0
    view := data[:]
    prev_measurement := math.sum(view[:3])
    view = view[1:]

    for len(view) >= 3 {
        measurement := math.sum(view[:3])
        fmt.print(prev_measurement, "-->", measurement, ' ')
        if prev_measurement < measurement  {
            increase_counter += 1
            fmt.println("Increase")
        } else {
            fmt.println("Decrease")
        }

        prev_measurement = measurement
        view = view[1:]
    }
    

    fmt.println("DAY 1 PART 2 RESULT:", increase_counter)
}