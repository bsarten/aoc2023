import Foundation

func get_hash(_ a : UInt, _ b : UInt) -> UInt {
    return ((a + b) * 17) % 256
}

func day1( _ input : String) -> UInt {
    var sum = UInt(0)
    for instruction in input.replacingOccurrences(of : "\n", with: "").components(separatedBy: ",") {
        var code = UInt(0)
        for ascii_value in  instruction.map({$0.asciiValue!}) {
            code = get_hash(code, UInt(ascii_value))    
        }
        sum += code
    }

    return sum
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let input = try String(contentsOf: input_path)

print(day1(input))
