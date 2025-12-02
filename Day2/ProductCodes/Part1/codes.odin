package codes

import os "core:os/os2"
import "core:fmt"
import "core:strings"
import "core:mem"
import "core:strconv"

ID_Range :: struct {
	start: int,
	end: int,
}

main :: proc() {
	answer_counter: uint

	file: []byte
	{
		error: os.Error
		file, error = os.read_entire_file("input", context.allocator)
		
		if error != nil {
			fmt.printfln("Error: %s", error)
			os.exit(1)
		}
	}

	input := strings.trim(string(file), "\n ")

	range_strings: []string
	{
		error: mem.Allocator_Error

		range_strings, error = strings.split(input, ",")
	}

	id_ranges := make([]ID_Range, len(range_strings))

	for range_string, i in range_strings {
		if range_string == "" do continue

		split_range, error := strings.split(range_string, "-", context.temp_allocator)
		if error != nil {
			fmt.printfln("Error: %s", error)
			os.exit(2)
		}

		start, start_ok := strconv.parse_int(split_range[0])
		if !start_ok {
			fmt.println("Reading start range failed")
			os.exit(3)
		}
		end, end_ok := strconv.parse_int(split_range[1])
		if !end_ok {
			fmt.println("Reading end range failed")
			os.exit(4)
		}
		
		id_ranges[i] = {start, end}
	}

	free_all(context.temp_allocator)

	for id_range in id_ranges {
		i := id_range.start
		for i < id_range.end {
			i_str := fmt.aprint(i, allocator = context.temp_allocator)
			if len(i_str) % 2 == 0 {
				halfway_rune_index := len(i_str) / 2
				first_half, ok := strings.substring_to(i_str, halfway_rune_index)
				second_half, ok2 := strings.substring_from(i_str, halfway_rune_index)
				if !ok || !ok2 {
					fmt.println("Havling substring failed")
					os.exit(5)
				}

				if first_half == second_half {
					fmt.printf("%d, ", i)
					answer_counter += uint(i)
				}

				
			} 
			
			i += 1
		}

		free_all(context.temp_allocator)
	}

	fmt.println()

	fmt.printfln("Answer: %d", answer_counter)

	delete(id_ranges)

	delete(range_strings)
	delete(file)
}