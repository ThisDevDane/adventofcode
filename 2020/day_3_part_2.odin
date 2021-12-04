package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
    data, ok := os.read_entire_file("./input/day_3.input");
    if ok != true {
        fmt.println("Error reading file.");
        os.exit(1);
    }

    one_one := tree_check(string(data), 1, 1);
    fmt.printf("We hit %d trees\n", one_one);
    three_one := tree_check(string(data), 3, 1);
    fmt.printf("we hit %d tree\n", three_one);
    five_one := tree_check(string(data), 5, 1);
    fmt.printf("we hit %d tree\n", five_one);
    seven_one := tree_check(string(data), 7, 1);
    fmt.printf("we hit %d tree\n", seven_one);
    one_two := tree_check(string(data), 1, 2);
    fmt.printf("we hit %d tree\n", one_two);
    fmt.printf("We hit %d trees\n", one_one*three_one*five_one*seven_one*one_two);


    fmt.println("END OF DAY 3 PART 2");
}


tree_check :: proc(data: string, right_move: int, down_move: int) -> int {
    x_iter := right_move;
    tree_count := 0;

    lines := strings.split(data, "\n")[down_move:];

    for i := 0; i < len(lines); {
        line := lines[i];

        runes := utf8.string_to_runes(line, context.temp_allocator);

        x := x_iter%len(runes);

        if runes[x] == '#' do tree_count += 1;

        runes[x] = runes[x] == '#' ? 'X' : '0';
        fmt.println(utf8.runes_to_string(runes, context.temp_allocator));

        x_iter += right_move;
        i += down_move;
    }

    return tree_count;
}