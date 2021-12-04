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

    x_iter := 3;
    tree_count := 0;

    for line in strings.split(string(data), "\n")[1:] {
        runes := utf8.string_to_runes(line, context.temp_allocator);

        x := x_iter%len(runes);

        if runes[x] == '#' do tree_count += 1;

        runes[x] = 'X';
        fmt.println(utf8.runes_to_string(runes, context.temp_allocator));

        x_iter += 3;
    }

    fmt.printf("We hit %d trees\n", tree_count);


    fmt.println("END OF DAY 3 PART 1");
}
