import Foundation

// shamelessly stolen from https://forums.swift.org/t/add-range-intersect-to-the-standard-library-analogous-to-nsintersectionrange/16757 
extension ClosedRange {
    public func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lowerBoundMax = Swift.max(self.lowerBound, other.lowerBound)
        let upperBoundMin = Swift.min(self.upperBound, other.upperBound)

        let lowerBeforeUpper = lowerBoundMax <= self.upperBound && lowerBoundMax <= other.upperBound
        let upperBeforeLower = upperBoundMin >= self.lowerBound && upperBoundMin >= other.lowerBound

        if lowerBeforeUpper && upperBeforeLower {
            return lowerBoundMax...upperBoundMin
        }

        return nil
    }
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"

if freopen(input_path, "r", stdin) == nil {
    perror(input_path)
    exit(1)
}

var line = readLine()!
let time = Int(line.components(separatedBy: ":")[1].components(separatedBy: " ").filter{!$0.isEmpty}.reduce(""){$0 + $1})!
let times = line.components(separatedBy: ":")[1].components(separatedBy: " ").filter{!$0.isEmpty}.map{Int($0)!}
line = readLine()!
let record = Int(line.components(separatedBy: ":")[1].components(separatedBy: " ").filter{!$0.isEmpty}.reduce(""){$0 + $1})!
let records = line.components(separatedBy: ":")[1].components(separatedBy: " ").filter{!$0.isEmpty}.map{Int($0)!}

// part 1
var total_ways = 1
for i in 0..<times.count {
    var num_ways = 0
    for time_held in 1..<times[i] {
        if time_held * (times[i] - time_held) > records[i] {
            num_ways += 1
        }
    }

    total_ways *= num_ways
}

print(total_ways) 

// part 2
var num_ways = 0
for time_held in 1..<time {
    if time_held * (time - time_held) > record {
        num_ways += 1
    }
}
print(num_ways)
