import Foundation

struct Card
{
    var ticket_numbers = Set<Int>()
    var my_numbers = Set<Int>()
    var copies = 1

    init(_ ticket_numbers : Set<Int>, _ my_numbers : Set<Int>){
        self.ticket_numbers = ticket_numbers
        self.my_numbers = my_numbers
    }
}


func get_number_set(_ number_str : String) -> Set<Int>{
    var new_set = Set<Int>()
    let number_array = number_str.split(separator: " ")
    for number in number_array {
        new_set.insert(Int(number)!)
    }
    return new_set
}

func score(_ intersection : Set<Int>) -> Int
{
    var score = 0
    if intersection.count > 0{
        score = Int(pow(Double(2), Double(intersection.count - 1)))
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
    var sum = 0
    for card_index in 0..<cards.count {
        let intersection = cards[card_index].my_numbers.intersection(cards[card_index].ticket_numbers)
        if intersection.count > 0 {
            for copy_index in card_index + 1...card_index + intersection.count {
                cards[copy_index].copies += cards[card_index].copies
            }
        }
        sum += cards[card_index].copies
    }

    print(sum)
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
    let ticket_numbers = get_number_set(String(matches!.1))
    let my_numbers = get_number_set(String(matches!.2))
    cards.append(Card(ticket_numbers, my_numbers))
}

part1(cards)
part2(&cards)
