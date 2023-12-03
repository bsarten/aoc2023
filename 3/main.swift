import Foundation

class part_number {
    var number = 0
    var row = 0
    var range : ClosedRange<Int> = 0...0

    init?(_ schematic : inout [[Character]], _ row : Int, _ col : Int){
        self.row = row
        var end_col = col
        while end_col < schematic[row].count && schematic[row][end_col].isNumber {
            self.number = self.number * 10 + schematic[row][end_col].wholeNumberValue!
            end_col += 1
        }
        if self.number != 0 {
            self.range = col...end_col-1
        }
        else {
            return nil
        }
    }
}

func find_part_numbers(_ schematic : inout [[Character]]) -> [part_number]{
    var part_numbers = [part_number]()

    for row in 0...schematic.count - 1 {
        var col = 0
        while col < schematic.count {
            if let part_number = part_number(&schematic, row, col) {
                part_numbers.append(part_number)
                col += part_number.range.last! - part_number.range.first! + 1
            }
            else {
                col += 1
            }
        }
    }

    return part_numbers
}

func read_schematic(_ filename : String) -> [[Character]] {
    var schematic = [[Character]]()
    if freopen(filename, "r", stdin) == nil {
        perror(input_path)
        exit(1)
    }

    while let line = readLine() {
        schematic.append(Array(line))
    }

    return schematic
}

func is_symbol(_ schematic : inout [[Character]], _ row : Int, _ col : Int) -> Bool {
    if row < 0 || row > schematic.count - 1 {
        return false
    }

    if col < 0 || col > schematic[row].count - 1 {
        return false
    }

    return !(schematic[row][col].isNumber || schematic[row][col] == ".")
}

func is_adjacent_to_symbol(_ schematic : inout [[Character]], _ row : Int, _ col : Int) -> Bool {
    for check_row in row-1...row+1 {
        for check_col in col-1...col+1 {
            if is_symbol(&schematic, check_row, check_col) {
                return true
            }
        }
    }

    return false
}

func is_adjacent_to_symbol(_ schematic : inout [[Character]], _ part_number : part_number) -> Bool {
    for col in part_number.range {
        if is_adjacent_to_symbol(&schematic, part_number.row, col){
            return true
        }
    }    
    return false
}

func get_part_number(_ part_numbers : inout [part_number], _ row : Int, _ col : Int) -> Int {
    for part_number in part_numbers {
        if part_number.row == row && part_number.range.contains(col) {
            return part_number.number
        }
    }

    return 0
}

func get_gear_ratio(_ schematic : inout [[Character]], _ part_numbers : inout [part_number], _ row : Int, _ col : Int) -> Int {
    if schematic[row][col] != "*" {
        return 0
    }

    var number_of_parts = 0
    var gear_ratio = 1

    var checked_parts_set = Set<Int>()

    for check_row in row-1...row+1 {
        for check_col in col-1...col+1 {
            if check_row >= 0 && check_row < schematic.count && check_col >= 0 && check_col < schematic[check_row].count {
                let part_number = get_part_number(&part_numbers, check_row, check_col)
                if (part_number > 0) {
                    if !checked_parts_set.contains(part_number) {
                        checked_parts_set.insert(part_number)
                        number_of_parts += 1
                        gear_ratio *= part_number
                    }
                }

            }
        }
    }

    if number_of_parts == 2 {
        return gear_ratio
    }
    else {
        return 0
    }
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"
var schematic = read_schematic(input_path)
var part_numbers = find_part_numbers(&schematic)
var sum = 0
for part_number in part_numbers {
    if is_adjacent_to_symbol(&schematic, part_number) {
        sum += part_number.number
    }
}

var ratio_sum = 0

for row in 0...schematic.count - 1 {
    for col in 0...schematic[row].count - 1 {
        if schematic[row][col] == "*" {
            ratio_sum += get_gear_ratio(&schematic, &part_numbers, row, col)
        }
    }
}

print(sum)
print(ratio_sum)