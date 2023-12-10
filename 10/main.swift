import Foundation


struct Coordinate {
    var x = 0
    var y = 0

    init(_ y : Int, _ x : Int) {
        self.x = x
        self.y = y
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

func find_path_length(_ map : [[Character]], _ traversed : inout [[Character]], _ start : Coordinate) -> Int {
    let char_translate : [Character:Character] = [
        "|" : "│",
        "J" : "┘",
        "L" : "└",
        "-" : "━",
        "F" : "┌",
        "7" : "┐",
        "S" : "S"
    ]

    var steps = 0
    var current_location = start
    repeat {
        traversed[current_location.y][current_location.x] = char_translate[map[current_location.y][current_location.x]] ?? " "
        switch map[current_location.y][current_location.x] {
            case "J":
                if traversed[current_location.y-1][current_location.x] != " "{
                    current_location.x -= 1
                }
                else if traversed[current_location.y-1][current_location.x] == " "{
                    current_location.y -= 1
                }
                else {
                    break
                }
            case "L":
                if traversed[current_location.y-1][current_location.x] != " "{
                    current_location.x += 1
                }
                else if traversed[current_location.y-1][current_location.x] == " "{
                    current_location.y -= 1
                }
                else {
                    break
                }
            case "F":
                if traversed[current_location.y+1][current_location.x] != " "{
                    current_location.x += 1
                }
                else if traversed[current_location.y+1][current_location.x] == " "{
                    current_location.y += 1
                }
                else {
                    break
                }
            case "|":
                if traversed[current_location.y+1][current_location.x] != " " {
                    current_location.y -= 1
                }
                else if traversed[current_location.y+1][current_location.x] == " "{
                    current_location.y += 1
                }
                else {
                    break
                }
            case "-":
                if traversed[current_location.y][current_location.x+1] != " "{
                    current_location.x -= 1
                }
                else if traversed[current_location.y][current_location.x+1] == " "{
                    current_location.x += 1
                }
                else {
                    break
                }
            case "7":
                if traversed[current_location.y][current_location.x-1] != " "{
                    current_location.y += 1
                }
                else if traversed[current_location.y][current_location.x-1] == " "{
                    current_location.x -= 1
                }
                else {
                    break
                }
            case "S":
                current_location = find_start_connection(map, current_location)
            default :
                exit(0)
        }
        steps += 1

        if traversed[current_location.y][current_location.x] != " "{
            break
        }
    } while map[current_location.y][current_location.x] != "S"

    return steps
}

func count_inside_tiles(_ traversed: inout [[Character]]) -> Int {
    var count = 0
    for col in 0..<traversed[0].count {
        var inside = false
        for row in 0..<traversed.count {
            if ["│", "┐", "┌", "S"].contains(traversed[col][row]) {
                inside = !inside
            }

            if inside && traversed[col][row] == " " {
                traversed[col][row] = "*"
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
