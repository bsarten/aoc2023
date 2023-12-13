import Foundation

struct ReflectionLine {

}
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

    func isReflection(in lines : [String], at center : ClosedRange<Int>) -> Bool {
        var is_reflection = true
        var range = center
        while range.upperBound < lines.count && range.lowerBound >= 0 {
            if lines[range.upperBound] != lines[range.lowerBound] {
                is_reflection = false
                break
            }

            range = (range.lowerBound - 1)...(range.upperBound + 1)
        }

        return is_reflection
    }

    func getReflection(in lines : [String]) -> ClosedRange<Int>? {
        var range : ClosedRange<Int>?
        for (row, line) in lines.enumerated() {
            if row == 0 { continue }
            if line == lines[row - 1] {
                if isReflection(in: lines, at:row-1...row) {
                    range = (row-1...row)
                    break
                }
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

    func getReflection() -> (ClosedRange<Int>, Bool) {
        let v_reflection = getReflection(in: rows)
        let h_reflection = getReflection(in: columns)

        if v_reflection != nil {
            Map.printReflection(v_reflection!, rows)
        }

        if h_reflection != nil {
            Map.printReflection(h_reflection!, columns)
        }

        return v_reflection != nil ? (v_reflection!, true) : (h_reflection!, false)
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
            let (reflection, isVertical) = map.getReflection()
            sum += isVertical ? (reflection.lowerBound+1) * 100 : reflection.lowerBound + 1
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