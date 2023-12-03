import Foundation

class PartNumber {
    var number = 0
    var row = 0
    var colRange : ClosedRange<Int> = 0...0

    init?(_ schematic : Schematic, _ row : Int, _ col : Int){
        self.row = row
        var end_col = col
        while end_col < schematic.colCount && schematic[row,end_col].isNumber {
            number = number * 10 + schematic[row,end_col].wholeNumberValue!
            end_col += 1
        }
        if number != 0 {
            colRange = col...end_col-1
        }
        else {
            return nil
        }
    }
}

class Schematic{
    private var data = [[Character]]()
    var partNumbers = [PartNumber]()

    init(filename : String){
        if freopen(filename, "r", stdin) == nil {
            perror(input_path)
            exit(1)
        }

        while let line = readLine() {
            data.append(Array(line))
        }

        parsePartNumbers()

        fclose(stdin)
    }

    subscript(row : Int, col : Int) -> Character {
        return data[row][col]
    }

    var rowCount : Int {
        get {
            return data.count
        }
    }

    var colCount : Int {
        get {
            return data[0].count
        }
    }

    private func parsePartNumbers() {
        for row in 0...rowCount - 1 {
            var col = 0
            while col < colCount {
                if let part_number = PartNumber(self, row, col) {
                    partNumbers.append(part_number)
                    col += part_number.colRange.last! - part_number.colRange.first! + 1
                }
                else {
                    col += 1
                }
            }
        }
    }

    func isSymbolAt(_ row : Int, _ col : Int) -> Bool {
        if row < 0 || row > rowCount - 1 {
            return false
        }

        if col < 0 || col > rowCount - 1 {
            return false
        }

        return !(data[row][col].isNumber || data[row][col] == ".")
    }

    func isAdjacentToSymbolAt(_ row : Int, _ col : Int) -> Bool {
        for check_row in row-1...row+1 {
            for check_col in col-1...col+1 {
                if schematic.isSymbolAt(check_row, check_col) {
                    return true
                }
            }
        }

        return false
    }

    func isAdjacentToSymbolAt(_ part_number : PartNumber) -> Bool {
        for col in part_number.colRange {
            if isAdjacentToSymbolAt(part_number.row, col){
                return true
            }
        }    
        return false
    }

    func getGearRatioAt(_ part_numbers : inout [PartNumber], _ row : Int, _ col : Int) -> Int {
        if data[row][col] != "*" {
            return 0
        }

        var number_of_parts = 0
        var gear_ratio = 1

        var checked_parts_set = Set<Int>()

        for check_row in row-1...row+1 {
            for check_col in col-1...col+1 {
                if check_row >= 0 && check_row < schematic.rowCount && check_col >= 0 && check_col < schematic.colCount {
                    if let part_number = getPartNumber(check_row, check_col){
                        if !checked_parts_set.contains(part_number.number) {
                            checked_parts_set.insert(part_number.number)
                            number_of_parts += 1
                            gear_ratio *= part_number.number
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

    func getPartNumber(_ row : Int, _ col : Int) -> PartNumber? {
        for part_number in partNumbers {
            if part_number.row == row && part_number.colRange.contains(col) {
                return part_number
            }
        }

        return nil
    }
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"
var schematic = Schematic(filename: input_path)
var part_numbers = schematic.partNumbers

// part 1
var sum = 0
for part_number in part_numbers {
    if schematic.isAdjacentToSymbolAt(part_number) {
        sum += part_number.number
    }
}
print(sum)

// part 2
var ratio_sum = 0
for row in 0...schematic.rowCount - 1 {
    for col in 0...schematic.colCount - 1 {
        if schematic[row,col] == "*" {
            ratio_sum += schematic.getGearRatioAt(&part_numbers, row, col)
        }
    }
}
print(ratio_sum)