import Foundation


struct Coordinate {
    var x = 0
    var y = 0

    init(_ y : Int, _ x : Int) {
        self.x = x
        self.y = y
    }

    static func += (_ lhs : inout Coordinate, _ rhs : Coordinate)
    {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func + (_ lhs : Coordinate, _ rhs : Coordinate) -> Coordinate {
        return Coordinate( lhs.y + rhs.y, lhs.x + rhs.x)
    }
}

func find_start_connection(_ map: [[Character]], _ start : Coordinate) -> Coordinate {
    if map[start.y][start.x+1] == "J" || map[start.y][start.x+1] == "-" {
        return Coordinate(start.y,start.x+1)
    }
    else if map[start.y][start.x-1] == "F" || map[start.y][start.x-1] == "-" {
        return Coordinate(start.y,start.x-1)
    }
    else if map[start.y+1][start.x] == "L" || map[start.y+1][start.x] == "|" {
        return Coordinate(start.y+1, start.x)
    }
    else if map[start.y-1][start.x] == "7" || map[start.y-1][start.x] == "|" {
        return Coordinate(start.y-1, start.x)
    }
    else {
        exit(0)
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

func find_path_length(_ map : [[Character]], _ traversed : inout [[Character]], _ start : Coordinate) -> Int {
    var steps = 0
    var current_location = start

    let LEFT = Coordinate(0, -1)
    let RIGHT = Coordinate(0, 1)
    let UP = Coordinate(-1, 0)
    let DOWN = Coordinate(1, 0)

    let traversal_map : [Character : PipeTraversal] = [
        "J" : PipeTraversal(UP, LEFT),
        "L" : PipeTraversal(UP, RIGHT),
        "F" : PipeTraversal(DOWN, RIGHT),
        "|" : PipeTraversal(UP, DOWN),
        "-" : PipeTraversal(LEFT, RIGHT),
        "7" : PipeTraversal(LEFT, DOWN)
    ]

    while true {
        traversed[current_location.y][current_location.x] = map[current_location.y][current_location.x]
        if map[current_location.y][current_location.x] == "S" {
            current_location = find_start_connection(map, current_location)
        }
        else {
            let traverse = traversal_map[map[current_location.y][current_location.x]]!
            let first_exit = current_location + traverse.first_exit
            let second_exit = current_location + traverse.second_exit
            if traversed[first_exit.y][first_exit.x] != " " && traversed[second_exit.y][second_exit.x] != " " {
                break
            }
            else if traversed[first_exit.y][first_exit.x] != " " {
                current_location = second_exit
            }
            else {
                current_location = first_exit
            }
        }

        steps += 1
    }

    return steps
}

func count_inside_tiles(_ traversed: inout [[Character]]) -> Int {
    var count = 0
    for col in 0..<traversed[0].count {
        var inside = false
        for row in 0..<traversed.count {
            if ["|", "7", "F", "S"].contains(traversed[col][row]) {
                inside = !inside
            }

            if inside && traversed[col][row] == " " {
                traversed[col][row] = " "
                count += 1
            }
        }
    }

    return count
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

var map = [[Character]]()
var traversed = [[Character]]()

var start : Coordinate?
map.append(Array(repeating:"x", count: lines[0].count + 2))
traversed.append(Array(repeating:" ", count: lines[0].count + 2))
for (y, line) in  lines.enumerated() {
    var new_line = Array(line)
    new_line.insert("x", at:0)
    new_line.append("x")
    map.append(new_line)
    traversed.append(Array(repeating: " ", count: new_line.count))
    guard let x = Array(new_line).firstIndex(of: "S") else {
        continue
    }

    start = Coordinate(y+1, new_line.distance(from:0, to:x))
}
map.append(Array(repeating:"x", count: lines[0].count + 2))
traversed.append(Array(repeating:" ", count: lines[0].count + 2))

// part 1
let path_length = find_path_length(map, &traversed, start!)
print(path_length / 2)

// part 2
print(count_inside_tiles(&traversed))
