import Foundation

func derivate_history(_ history : inout [[Int]]) {
    while (history.last!.reduce(0){$0 + $1}) != 0 {
        history.append(zip(history.last!, history.last!.dropFirst()).map{$0.1 - $0.0})
    }
}

func integrate_history(_ history : inout [[Int]], _ line_to_integrate : Int) {
    history[line_to_integrate].append(history[line_to_integrate+1].last! + history[line_to_integrate].last!)
    if line_to_integrate == 0 {
        return
    }
    integrate_history(&history, line_to_integrate - 1)
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

// part 1
var sum = 0
for line in lines {
    var history = [[Int]]()
    history.append(line.components(separatedBy: " ").map{Int($0)!})
    derivate_history(&history)
    history[history.count - 1].append(0)
    integrate_history(&history, history.count - 2)
    sum += history.first!.last!
}

print(sum)

// part 2
sum = 0
for line in lines {
    var history = [[Int]]()
    history.append(line.components(separatedBy: " ").map{Int($0)!}.reversed())
    derivate_history(&history)
    history[history.count - 1].append(0)
    integrate_history(&history, history.count - 2)
    sum += history.first!.last!
}

print(sum)

