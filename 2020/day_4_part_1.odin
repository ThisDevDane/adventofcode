package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:text/scanner"

field_map: map[string]bool = {
    "byr" = true,
    "iyr" = true,
    "eyr" = true,
    "hgt" = true,
    "hcl" = true,
    "ecl" = true,
    "pid" = true,
    // "cid" = false,
};

SCAN_FLAGS :: scanner.Scan_Flags{.Scan_Idents};
SCAN_WHITESPACE :: 1<<'\t' | 1<<'\r' | 1<<' ';

main :: proc() {
    data, ok := os.read_entire_file("./input/day_4.input");
    if ok != true {
        fmt.println("Error reading file.");
        os.exit(1);
    }

    s := scanner.Scanner{};

    scanner.init(&s, string(data));
    s.flags = SCAN_FLAGS;
    s.whitespace = SCAN_WHITESPACE;

    num_passports := 0;
    num_valid_passports := 0;
    num_fields_present := 0;

    for {
        if is_new_passport(&s) || scanner.peek(&s) == scanner.EOF {
            fmt.printf("Number of fields: %d/%d ", num_fields_present, len(field_map));
            if num_fields_present == len(field_map) {
                num_valid_passports += 1;
                fmt.println("Valid!");
            } else {
                fmt.println("Invalid!");
            }


            num_passports += 1;
            num_fields_present = 0;

            if scanner.peek(&s) == scanner.EOF do break;
        }

        tok := scanner.scan(&s);
        if tok == scanner.Ident {
            if scanner.peek(&s) == ':' {
                key := scanner.token_text(&s);
                // fmt.println("Found key: ", key);
                _, ok := field_map[scanner.token_text(&s)];
                if ok == true do num_fields_present += 1;
            }
        }
        // fmt.println(scanner.token_string(tok), scanner.token_text(&s));
    }

    fmt.printf("Number of valid passports: %d/%d\n", num_valid_passports, num_passports);

    fmt.println("END OF DAY 4 PART 1");
}

is_new_passport :: proc(s: ^scanner.Scanner) -> bool {
    if scanner.peek(s) == '\n' {
        scanner.next(s);
        if scanner.peek(s) == '\n' {
            scanner.next(s);
            return true;
        }
    }

    return false;
}