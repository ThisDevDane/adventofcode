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

is_password_valid :: proc(min: int, max: int, letter: rune, password: string) -> (bool, bool) {
    runes := utf8.string_to_runes(password);

    if min-1 < 0 do return false, false;
    if max-1 >= len(runes) do return false, false;

    x := runes[min-1] == letter;
    y := runes[max-1] == letter;

    return x != y, true;
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

        valid, ok := is_password_valid(min, max, letter, password);
        if ok == false do scanner.errorf(&s, "ERROR IN VALIDATION LOGIC! args: %v %v %v %v", min, max, letter, password);
        if valid do num_valid += 1;
    }

    fmt.println("Number of valid:", num_valid);

    fmt.println("END OF DAY 2 PART 2");
}