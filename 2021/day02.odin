package main

import "core:fmt"
import "core:strconv"
import "core:math/linalg"
import "core:text/scanner"

import "utils"

main :: proc() {
    data := utils.read_day_input_to_string("02")

    part1(data)
    part2(data)
}

part1 :: proc(data: string) {
    pos := [2]int{} // Vec2

    s := scanner.Scanner{}
    scanner.init(&s, data)

    for scanner.peek(&s) != scanner.EOF {
        scanner.scan(&s)
        direction := scanner.token_text(&s)
        scanner.scan(&s)
        units, _ := strconv.parse_int(scanner.token_text(&s))

        switch direction {
        case "forward":
            pos.x += units
        case "up":
            pos.y -= units
        case "down":
            pos.y += units
        }

        fmt.print("Input:", direction, units)
        fmt.println(" New position:", pos)
    }

    fmt.println("DAY 2 PART 1 RESULT:", pos.x * pos.y)
}

part2 :: proc(data: string) {
    pos := [3]int{} // Vec3 Z is "AIM"

    s := scanner.Scanner{}
    scanner.init(&s, data)

    for scanner.peek(&s) != scanner.EOF {
        scanner.scan(&s)
        direction := scanner.token_text(&s)
        scanner.scan(&s)
        units, _ := strconv.parse_int(scanner.token_text(&s))

        switch direction {
        case "forward":
            pos.x += units
            pos.y += units * pos.z
        case "up":
            pos.z -= units
        case "down":
            pos.z += units
        }

        fmt.print("Input:", direction, units)
        fmt.println(" New position:", pos)
    }

    fmt.println("DAY 2 PART 2 RESULT:", pos.x * pos.y)
}