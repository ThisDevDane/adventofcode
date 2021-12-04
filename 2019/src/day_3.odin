package main;

import "core:fmt";
import "core:os";
import "core:strings";
import "core:unicode/utf8";

day_3 :: proc() {
    fmt.println("==== Day 3 ====");

//    fmt.printf("Puzzle 1: %v\n", code[0]);
    data, _ := os.read_entire_file("day_3_puzzle_1.txt");
    wires := strings.split(string(data), "\n");

    wire_1_route := strings.split(wires[0], ",");
    wire_2_route := strings.split(wires[1], ",");

    for instr in wire_1_route {
        dir := utf8.rune_at_pos(instr, 0);
        distance := instr[utf8.rune_offset(instr, 1):];
    }

    fmt.println("---- Day 3 Done ----");
}