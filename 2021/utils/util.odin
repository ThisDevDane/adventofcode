package util

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

read_day_input_to_string_slice :: proc(day: string) -> []string {
    path := fmt.tprintf("./input/day%v.txt", day)
    data, ok := os.read_entire_file(path)
    if ok != true {
        fmt.printf("Error reading file for day %v.\n", day)
        os.exit(1)
    }

    lines := strings.split(string(data), "\n")

    return lines
}

read_day_input_to_integer_slice :: proc(day: string) -> []int {
    path := fmt.tprintf("./input/day%v.txt", day)
    data, ok := os.read_entire_file(path)
    if ok != true {
        fmt.printf("Error reading file for day %v.\n", day)
        os.exit(1)
    }

    lines := strings.split(string(data), "\n")
    numbers := make([]int, len(lines))
    for l, idx in lines {
        x, _ := strconv.parse_int(l)
        numbers[idx] = x
    }

    return numbers
}