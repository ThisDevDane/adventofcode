package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode/utf8"
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

SCAN_FLAGS :: scanner.Scan_Flags{.Scan_Idents, .Scan_Ints, .Scan_Floats};
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
    num_valid_fields_present := 0;

    for {
        if is_new_passport(&s) || scanner.peek(&s) == scanner.EOF {
            fmt.printf("Number of fields: %d/%d ", num_valid_fields_present, len(field_map));
            if num_valid_fields_present == len(field_map) {
                num_valid_passports += 1;
                fmt.println("Valid!");
            } else {
                fmt.println("Invalid!");
            }


            num_passports += 1;
            num_valid_fields_present = 0;

            if scanner.peek(&s) == scanner.EOF do break;
            // break;
        }

        tok := scanner.scan(&s);
        if tok == scanner.Ident {
            if scanner.peek(&s) == ':' {
                field := scanner.token_text(&s);
                scanner.next(&s);
                if validate_field(field, &s) do num_valid_fields_present += 1;
            }
        }
        // fmt.println(scanner.token_string(tok), scanner.token_text(&s));
    }

    fmt.printf("Number of valid passports: %d/%d\n", num_valid_passports, num_passports);

    fmt.println("END OF DAY 4 PART 2");
}

validate_field :: proc(field: string, s: ^scanner.Scanner) -> bool {
    key := scanner.token_text(s);
    switch field {
        case "byr":
            byr := scanner.scan(s);
            if byr != scanner.Int do return false;
            year := strconv.atoi(scanner.token_text(s));
            return year >= 1920 && year <= 2002;
        case "iyr":
            iyr := scanner.scan(s);
            if iyr != scanner.Int do return false;
            year := strconv.atoi(scanner.token_text(s));
            return year >= 2010 && year <= 2020;
        case "eyr":
            eyr := scanner.scan(s);
            if eyr != scanner.Int do return false;
            year := strconv.atoi(scanner.token_text(s));
            return year >= 2020 && year <= 2030;
        case "hgt":
            hgt := scanner.scan(s);
            if hgt != scanner.Int do return false;
            height := strconv.atoi(scanner.token_text(s));
            if scanner.scan_peek(s) != scanner.Ident {
                return false;
            }
            scanner.scan(s);
            unit := scanner.token_text(s);
            switch unit {
                case "cm": return height >= 150 && height <= 193;
                case "in": return height >= 59 && height <= 76;
                case: 
                    fmt.println(unit);
                    return false;
            }
        case "hcl":
            validate_hcl_part :: proc(tok: rune) -> bool {
                switch tok {
                    case '0'..'9': return true;
                    case 'a'..'f': return true;
                }

                fmt.println(tok);
                return false;
            }

            hcl := scanner.next(s);
            if hcl != '#' do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;
            if validate_hcl_part(scanner.next(s)) == false do return false;

            return true;

        case "ecl":
            ecl := scanner.scan(s);
            if ecl != scanner.Ident do return false;
            switch scanner.token_text(s) {
                case "amb", "blu", "brn", "gry", "grn", "hzl", "oth":
                    return true;
                case:
                    return false;
            }

        case "pid":
            digits := 0;
            for scanner.peek(s) == '0' {
                digits += 1;
                scanner.next(s);
            }

            pid := scanner.scan(s);
            if pid != scanner.Int do return false;

            number := strconv.atoi(scanner.token_text(s));
            
            for number != 0 {
                digits += 1;
                number /= 10;
            }
            return digits == 9;
    }

    return false;
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