import Foundation

func derivate_history(_ history : inout [[Int]]) {
    let line_to_derivate = history.last!
    var new_line = [Int]()
    for index in 1..<line_to_derivate.count {
        new_line.append(line_to_derivate[index] - line_to_derivate[index - 1])
    }
    history.append(new_line)
    if (new_line.reduce(0){$0 + $1}) != 0{
        derivate_history(&history)
    }

    return
}

func integrate_history_forward(_ history : inout [[Int]], _ line_to_integrate : Int) {
    history[line_to_integrate].append(history[line_to_integrate+1].last! + history[line_to_integrate].last!)
    if line_to_integrate == 0 {
        return
    }
    integrate_history_forward(&history, line_to_integrate - 1)
}

func integrate_history_backward(_ history : inout [[Int]], _ line_to_integrate : Int) {
    history[line_to_integrate].insert(history[line_to_integrate].first! - history[line_to_integrate+1].first!, at: 0)
    if line_to_integrate == 0 {
        return
    }
    integrate_history_backward(&history, line_to_integrate - 1)
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
    integrate_history_forward(&history, history.count - 2)
    sum += history.first!.last!
}

print(sum)

// part 2
sum = 0
for line in lines {
    var history = [[Int]]()
    history.append(line.components(separatedBy: " ").map{Int($0)!})
    derivate_history(&history)
    history[history.count - 1].insert(0, at: 0)
    integrate_history_backward(&history, history.count - 2)
    sum += history.first!.first!
}

print(sum)

