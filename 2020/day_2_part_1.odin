package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode/utf8"
import "core:text/scanner"

get_with_expect :: proc(s: ^scanner.Scanner, expected: rune) -> rune {
    tok := scanner.scan(s);
    fmt.assertf(tok == expected, 
                "NON EXPECTED TOKEN! EXPECTED: '%v' ACTUAL: '%v'\nLoc: '%v'", 
                scanner.token_string(expected), 
                scanner.token_string(tok),
                scanner.position(s));
    return tok;
}

is_password_valid :: proc(min: int, max: int, letter: rune, password: string) -> bool {
    count := 0;

    for r in password {
        if r == letter do count += 1;
    }

    return count <= max && count >= min;
}

main :: proc() {
    data, ok := os.read_entire_file("./input/day_2.input");
    if ok != true {
        fmt.println("Error reading file.");
        os.exit(1);
    }

    s := scanner.Scanner{};

    scanner.init(&s, string(data));

    num_valid := 0;

    for scanner.peek(&s) != scanner.EOF {
        get_with_expect(&s, scanner.Int);
        min := strconv.atoi(scanner.token_text(&s));
        get_with_expect(&s, '-');
        get_with_expect(&s, scanner.Int);
        max := strconv.atoi(scanner.token_text(&s));
        get_with_expect(&s, scanner.Ident);
        letter, _ := utf8.decode_rune_in_string(scanner.token_text(&s));
        get_with_expect(&s, ':');
        get_with_expect(&s, scanner.Ident);
        password := scanner.token_text(&s);

        valid := is_password_valid(min, max, letter, password);
        if valid do num_valid += 1;
    }

    fmt.println("Number of valid:", num_valid);


    fmt.println("END OF DAY 2 PART 1");
}