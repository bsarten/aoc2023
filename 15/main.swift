import Foundation

func get_hash(_ a : UInt, _ b : UInt) -> UInt {
    return ((a + b) * 17) % 256
}

func get_hash(_ str : String) -> UInt {
    var code = UInt(0)
    for ascii_value in  str.map({$0.asciiValue!}) {
        code = get_hash(code, UInt(ascii_value))    
    }

    return code
}

func day1( _ input : String) -> UInt {
    var sum = UInt(0)
    for instruction in input.replacingOccurrences(of : "\n", with: "").components(separatedBy: ",") {
        sum += get_hash(instruction)
    }

    return sum
}

struct Lens {
    let name : String
    var value : Int

    init(_ name : String, _ value : Int){
        self.name = name
        self.value = value
    }
}

func day2( _ input : String) -> Int {
    var boxes = [[Lens]](repeating: [Lens](), count: 256)
    let search = #/^(.*)([-=])([0-9]+)?$/#
    for instruction in input.replacingOccurrences(of : "\n", with: "").components(separatedBy: ",") {
        let matches = instruction.wholeMatch(of:search)!.output
        let name = String(matches.1)
        let op = String(matches.2)
        let arg = Int(matches.3 ?? "0")!
        let box_number = Int(get_hash(String(name)))

        switch op {
            case "=":
                if let lens_index = boxes[box_number].firstIndex(where: {$0.name == name}) {
                    boxes[box_number][lens_index].value = arg
                }
                else {
                    boxes[box_number].append(Lens(name, arg))
                }
            case "-": 
                if let lens_index = boxes[box_number].firstIndex(where: {$0.name == name}) {
                    boxes[box_number].remove(at: lens_index)
                }
            default:
                break
        }
    }

    var sum = 0
    for (box_index, lenses) in boxes.enumerated() {
        for (lens_index, lens) in lenses.enumerated() {
            sum += (box_index + 1) * (lens_index + 1) * Int(lens.value)
        }
    }
    return sum 
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let input = try String(contentsOf: input_path)

print(day1(input))
print(day2(input))
