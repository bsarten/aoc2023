import Foundation

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

struct PipeTraversal {
    let first_exit : Coordinate
    let second_exit : Coordinate
    
    init(_ first_exit : Coordinate, _ second_exit : Coordinate) {
        self.first_exit = first_exit
        self.second_exit = second_exit
    }
}

struct Map {
    var map = [[Character]]()

    mutating func set(_ coordinate : Coordinate, _ char : Character) {
        map[coordinate.y][coordinate.x] = char
    }

    func get(_ coordinate : Coordinate) -> Character {
        return map[coordinate.y][coordinate.x]
    }
}

class Day10 {
    var start = Coordinate(0,0)
    var map = Map() 
    var traversed = Map() 

    let LEFT : Coordinate
    let RIGHT : Coordinate
    let UP : Coordinate
    let DOWN : Coordinate

    let traversal_map : [Character : PipeTraversal] 

    init(_ lines : [String]) {
        LEFT = Coordinate(0, -1)
        RIGHT = Coordinate(0, 1)
        UP = Coordinate(-1, 0)
        DOWN = Coordinate(1, 0)

        traversal_map = [
            "J" : PipeTraversal(UP, LEFT),
            "L" : PipeTraversal(UP, RIGHT),
            "F" : PipeTraversal(DOWN, RIGHT),
            "|" : PipeTraversal(UP, DOWN),
            "-" : PipeTraversal(LEFT, RIGHT),
            "7" : PipeTraversal(LEFT, DOWN)
        ]
        
        map.map.append(Array(repeating:"x", count: lines[0].count + 2))
        traversed.map.append(Array(repeating:" ", count: lines[0].count + 2))
        for (y, line) in  lines.enumerated() {
            var new_line = Array(line)
            new_line.insert("x", at:0)
            new_line.append("x")
            map.map.append(new_line)
            traversed.map.append(Array(repeating: " ", count: new_line.count))
            guard let x = Array(new_line).firstIndex(of: "S") else {
                continue
            }

            start = Coordinate(y+1, new_line.distance(from:0, to:x))
        }
        map.map.append(Array(repeating:"x", count: lines[0].count + 2))
        traversed.map.append(Array(repeating:" ", count: lines[0].count + 2))
    }
    
    private func find_start_connection() -> Coordinate {
        if map.get(start + RIGHT) == "J" || map.get(start + RIGHT) == "-" {
            return start + RIGHT
        }
        else if map.get(start + LEFT) == "F" || map.get(start + LEFT) == "-" {
            return start + LEFT
        }
        else if map.get(start + UP) == "L" || map.get(start + UP) == "|" {
            return start + UP
        }
        else if map.get(start + DOWN) == "7" || map.get(start + DOWN) == "|" {
            return start + DOWN
        }
        else {
            exit(0)
        }
    }

    func find_path_length() -> Int {
        var steps = 0
        var current_location = start
        var last_location : Coordinate?

        repeat {
            traversed.set(current_location, map.get(current_location))
            if current_location == start {
                current_location = find_start_connection()
                last_location = start
            }
            else {
                let traverse = traversal_map[map.get(current_location)]!
                let first_exit = current_location + traverse.first_exit
                let second_exit = current_location + traverse.second_exit
                let new_location = first_exit == last_location ? second_exit : first_exit
                last_location = current_location
                current_location = new_location
            }

            steps += 1
        } while current_location != start

        return steps
    }

    func count_inside_tiles() -> Int {
        var count = 0
        for col in 0..<traversed.map[0].count {
            var inside = false
            for row in 0..<traversed.map.count {
                let location = Coordinate(col, row)
                if ["|", "7", "F", "S"].contains(traversed.get(location)) {
                    inside = !inside
                }

                if inside && traversed.get(location) == " " {
                    traversed.set(location, " ")
                    count += 1
                }
            }
        }

        return count
    }
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

let day10 = Day10(lines)

// part 1
let path_length = day10.find_path_length()
print(path_length / 2)

// part 2
print(day10.count_inside_tiles())