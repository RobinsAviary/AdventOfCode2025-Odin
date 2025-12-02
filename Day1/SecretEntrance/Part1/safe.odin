package safe

import os "core:os/os2"
import "core:fmt"
import "core:strings"
import "core:unicode/utf8"
import "core:strconv"

Rotation_Direction :: enum {
	Left,
	Right,
}

main :: proc() {
	input, error := os.read_entire_file("input", context.allocator)
	input_str := strings.trim(string(input), "\n ") // Remove messy file stuff

	if error != nil {
		fmt.println("Error: %s", error)
		os.exit(1)
	}

	split_input := strings.split_lines(input_str)

	//fmt.println(split_input)

	direction: Rotation_Direction
	rotation: int = 50
	password_count: uint

	for item in split_input {
		first_rune := utf8.rune_at_pos(item, 0)

		switch(first_rune) {
			case 'L':
				direction = .Left
			case 'R':
				direction = .Right
		}

		number: int

		{
			number_str, ok := strings.substring_from(item, 1)
			if !ok do os.exit(2)
			number, ok = strconv.parse_int(number_str)
			if !ok do os.exit(3)
		}

		switch direction {
			case .Left:
				rotation -= number
			case .Right:
				rotation += number
		}

		for rotation < 0 {
			rotation += 100
		}
		for rotation > 99 {
			rotation -= 100
		}

		if rotation == 0 {
			password_count += 1
		}

		//fmt.print(direction, number, rotation, password_count, "  \\  ")
	}

	fmt.println(password_count)

	delete(split_input)
	delete(input)
}