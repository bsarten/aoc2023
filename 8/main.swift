import Foundation

struct MapNode {
    var name : String
    var left : String
    var right : String

    init(_ name : String, _ left : String, _ right : String){
        self.name = name
        self.left = left
        self.right = right
    }
}

func part1(_ map : inout [String:MapNode], _ directions : inout [String], _ node_name : String, _ end_node : String) -> Int {
    var steps = 0
    var index = 0

    var current_node_name = node_name
    while !current_node_name.reversed().starts(with: end_node) {
        let current_node = map[current_node_name]!
        let direction = directions[index]
        if direction == "L" {
            current_node_name = current_node.left
        }
        else {
            current_node_name = current_node.right
        }
        steps += 1
        index = (index + 1) % (directions.count)
    }

    return steps
}

func part2(_ map : inout [String:MapNode], _ directions : inout [String], _ node_name : String) -> [Int] {
    var a_nodes = [String]()
    for key in map.filter({$1.name.last == "A"}).keys {
        a_nodes.append(key)
    }
    var loop_lengths = [Int]()
    for check_name in a_nodes {
        loop_lengths.append(part1(&map, &directions, check_name, "Z"))
    }

    return loop_lengths
}

var map = [String:MapNode]()

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

var directions = Array(lines[0]).map{String($0)}

var root_name = "AAA"

for map_line in lines.dropFirst(1) {
    let search = #/^(.*) = \((.*), (.*)\)$/#
    let matches = map_line.wholeMatch(of:search)?.output

    let node_name = String(matches!.1)
    let left_name = String(matches!.2)
    let right_name = String(matches!.3)
    
    map[node_name] = MapNode(node_name, left_name, right_name)
}

print(part1(&map, &directions, root_name, "ZZZ"))
print("LCM of : ")
print(part2(&map, &directions, root_name))
