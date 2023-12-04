import Foundation

struct Card
{
    var ticket_numbers = Set<String>()
    var my_numbers = Set<String>()
    var copies = 1

    init(_ ticket_numbers : Set<String>, _ my_numbers : Set<String>){
        self.ticket_numbers = ticket_numbers
        self.my_numbers = my_numbers
    }
}

func score(_ intersection : Set<String>) -> Int
{
    var score = 0
    if intersection.count > 0{
        score = Int(pow(2.0, Double(intersection.count - 1)))
    }
    return score
}

func part1(_ cards : [Card]){
    var sum = 0
    for i in 0..<cards.count {
        let intersection = cards[i].my_numbers.intersection(cards[i].ticket_numbers)
        sum += score(intersection)
    }
    print(sum)
}

func part2(_ cards : inout [Card]){
    for card_index in 0..<cards.count {
        let intersection = cards[card_index].my_numbers.intersection(cards[card_index].ticket_numbers)
        if intersection.count > 0 {
            for copy_index in card_index + 1...card_index + intersection.count {
                cards[copy_index].copies += cards[card_index].copies
            }
        }
    }

    print(cards.reduce(0){$0 + $1.copies})
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"

if freopen(input_path, "r", stdin) == nil {
    perror(input_path)
    exit(1)
}

var cards = [Card]()
while let line = readLine() {
    let search = #/^Card\s+[\d]+:(.*) \| (.*)$/#
    let matches = line.wholeMatch(of:search)?.output
    let ticket_numbers = Set(matches!.1.components(separatedBy: " ").filter{!$0.isEmpty})
    let my_numbers = Set(matches!.2.components(separatedBy: " ").filter{!$0.isEmpty})
    cards.append(Card(ticket_numbers, my_numbers))
}

part1(cards)
part2(&cards)
