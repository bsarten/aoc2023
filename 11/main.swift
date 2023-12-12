import Foundation

class Day11 {
    var map = [[Character]]()
    var rows_empty = [Int]()
    var cols_empty = [Int]()
    var galaxies = [Coordinate]()

    init(_ lines : [String]){
        for (row, line) in lines.enumerated() {
            if line.firstIndex(where: { $0 != "."}) == nil {
                rows_empty.append(row)
            }
        }

        for col in 0..<lines[0].count {
            var found = false
            for row in 0..<lines.count  {
                let lines_arr = Array(lines[row])
                if lines_arr[col] == "#" {
                    found = true
                    galaxies.append(Coordinate(col, row))
                }
            }
            if !found {
                    cols_empty.append(col)
            }
        }
    } 

    struct Coordinate : Equatable {
        var x = 0
        var y = 0

        init(_ y : Int, _ x : Int) {
            self.x = x
            self.y = y
        }

        static func += (_ lhs : inout Coordinate, _ rhs : Coordinate) {
            lhs.x += rhs.x
            lhs.y += rhs.y
        }

        static func + (_ lhs : Coordinate, _ rhs : Coordinate) -> Coordinate {
            return Coordinate( lhs.y + rhs.y, lhs.x + rhs.x)
        }

        static func == (_ lhs : Coordinate, _ rhs : Coordinate) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
    }

    struct Galaxy {
        let location : Coordinate

        init(_ location : Coordinate) {
            self.location = location
        }
    }

    func calculate_distance(_ from : Coordinate, _ to : Coordinate, _ expansion : Int) -> Int {
        var distance = abs(from.x - to.x) + abs(from.y - to.y)
        if (from.x < to.x) {
            distance += rows_empty.filter{(from.x...to.x).contains($0)}.count * (expansion - 1)
        }
        else if to.x != from.x {
            distance += rows_empty.filter{(to.x...from.x).contains($0)}.count * (expansion - 1)
        }
        if (from.y < to.y) {
            distance += cols_empty.filter{(from.y...to.y).contains($0)}.count * (expansion - 1)
        }
        else if from.y != to.y {
            distance += cols_empty.filter{(to.y...from.y).contains($0)}.count * (expansion - 1)
        }

        return distance
    }

    func do_part(expansion : Int) {
        var galaxies_used = Set<String>()
        var sum = 0
        for (from_index, from_galaxy) in galaxies.enumerated() {
            for (to_index, to_galaxy) in galaxies.enumerated() {
                if galaxies_used.contains("\(to_index)->\(from_index)") {
                    continue
                }

                if from_index == to_index {
                    continue
                }

                galaxies_used.insert("\(from_index)->\(to_index)")
                sum += calculate_distance(from_galaxy, to_galaxy, expansion)
            }
        } 

        print(sum)
    }
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

let day11 = Day11(lines)
day11.do_part(expansion : 2)
day11.do_part(expansion : 1000000)
