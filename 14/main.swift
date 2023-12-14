import Foundation

let example_input =  """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""

let example = false

struct Coordinate : Equatable {
    var x = 0
    var y = 0

    init(_ x : Int, _ y : Int) {
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

struct Cube : Equatable {
    var location : Coordinate

    init(_ x : Int, _ y : Int) {
        location = Coordinate(x, y)
    }

}

struct Sphere {
    let location : Coordinate

    init(_ x : Int, _ y : Int) {
        location = Coordinate(x, y)
    }

    static func != (_ lhs : Sphere, _ rhs : Sphere) -> Bool {
        return lhs.location != rhs.location
    }
}

class Day14 {
    var spheres = [Sphere]()
    var cubes = [Cube]()
    var max_y = 0
    init() {
    }

    func prepareData(_ input : String){
        let lines = input.components(separatedBy:"\n").filter{!$0.isEmpty}
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                if char == "O" {
                    spheres.append(Sphere(x, y))
                }
                else if char == "#" {
                    cubes.append(Cube(x, y))
                }
            }
        }
        max_y = lines.count
    }

    func part1() -> Int {
        var load = 0

        cubes.sort(by: {$0.location.y > $1.location.y})

        for sphere in spheres {
            var closest_cube_y = -1
            if let closest_northern_cube = cubes.filter({$0.location.y < sphere.location.y && $0.location.x == sphere.location.x}).first {
                closest_cube_y = closest_northern_cube.location.y
            }
            
            let spheres_inbetween = spheres.filter{$0.location.x == sphere.location.x }.filter{$0.location.y > closest_cube_y && $0.location.y <= sphere.location.y}
            let final_y_position = closest_cube_y + spheres_inbetween.count
            load +=  max_y - final_y_position
        }
        return load
    }
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let input = example ? example_input : try String(contentsOf: input_path)

var day14 = Day14()
day14.prepareData(input)
print(day14.part1())

