import Foundation

struct Map {
    let rows : [String]
    var columns : [String]

    init(_ lines : [String]) {
        self.rows = lines
        columns = [String](repeating: "", count: rows[0].count)
        for row in rows {
            for (column, c) in row.enumerated() {
                columns[column] += String(c)
            }
        }
    }

    func isReflection(in lines : [String], at center : ClosedRange<Int>, _ smudge : Bool) -> Bool {
        var is_reflection = true
        var range = center
        var differences = 0
        while range.upperBound < lines.count && range.lowerBound >= 0 {
            differences += Map.compareLine(lines[range.upperBound], lines[range.lowerBound])
            if differences > (smudge ? 1 : 0) {
                is_reflection = false
                break
            }

            range = (range.lowerBound - 1)...(range.upperBound + 1)
        }

        if smudge && differences != 1 {
            return false
        }
        return is_reflection
    }

    static func compareLine(_ lhs : String, _ rhs : String) -> Int {
        if lhs == rhs {
            return 0
        }

        var differences = 0
        for (index, char) in lhs.enumerated() {
            if char != rhs[rhs.index(rhs.startIndex, offsetBy: index)] {
                differences += 1
            }
        }

        return differences
    }

    func getReflection(in lines : [String], _ smudge : Bool) -> ClosedRange<Int>? {
        var range : ClosedRange<Int>?
        for (row, _) in lines.enumerated() {
            if row == 0 { continue }
            if isReflection(in: lines, at:row-1...row, smudge) {
                range = (row-1...row)
                break
            }

        }

        return range
    }

    static func printReflection(_ reflection : ClosedRange<Int>, _ lines : [String]) {
        for (index, line) in lines.enumerated() {
            var indicator = ""
            if index == reflection.lowerBound {
                indicator = "v"
            }
            else if index == reflection.upperBound {
                indicator = "^"
            }
            print("\(line) \(index)\(indicator)")
        }

        print()
    }

    func getReflection(_ smudge : Bool) -> (ClosedRange<Int>, Bool)? {
        if let v_reflection = getReflection(in: rows, smudge) {
            return (v_reflection, true)
        }

        if let h_reflection = getReflection(in: columns, smudge) {
            return (h_reflection, false)
        }

        return nil 
    }
}

class Day13 {
    var maps = [Map]()

    func prepareData(with input : String){
        let maps_input = input.components(separatedBy:"\n\n").filter{!$0.isEmpty}
        for map_input in maps_input {
            let lines = map_input.components(separatedBy:"\n").filter{!$0.isEmpty}
            maps.append(Map(lines))
        } 
    }

    func part1() -> Int {
        var sum = 0
        for map in maps {
            if let (reflection, isVertical) = map.getReflection(false) {
                sum += isVertical ? (reflection.lowerBound+1) * 100 : reflection.lowerBound + 1
            }
        }
        return sum
    }


    func part2() -> Int {
        var sum = 0
        for map in maps {
            if let (reflection, isVertical) = map.getReflection(true) {
                sum += isVertical ? (reflection.lowerBound+1) * 100 : reflection.lowerBound + 1
            }
        }
        return sum
    }
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let input = try String(contentsOf: input_path)

let day13 = Day13()
day13.prepareData(with: input)

// part 1 
print(day13.part1())
print(day13.part2())