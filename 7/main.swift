import Foundation

struct CardCollectionCounts {
    var pairs = 0
    var threes = 0
    var fives = 0
    var fours = 0
}

struct Hand {
    let cards : String
    let bid : Int
    let hand_type : Int
    static var card_value = [
        "2" : 2,
        "3" : 3,
        "4" : 4,
        "5" : 5,
        "6" : 6,
        "7" : 7,
        "8" : 8,
        "9" : 9,
        "T" : 10,
        "J" : 11,
        "Q" : 12,
        "K" : 13,
        "A" : 14
    ]

    static func getCardCounts(_ cards : String) -> [Character:Int] {
        var card_count = [Character:Int]()
        for card in Array(cards) {
            card_count[card, default: 0] += 1
        }
        return card_count
    }

    init(_ cards : String, _ bid : Int, using_jokers : Bool) {
        self.cards = cards
        self.bid = bid

        if using_jokers {
            let card_count = Hand.getCardCounts(cards)
            let max_card = card_count.max(by: {($0.key == "J" ? 0 : $0.value) < ($1.key == "J" ? 0 : $1.value)})
            let cards_joker_replaced = String(cards.map{$0 == "J" ? max_card!.key : $0})
            self.hand_type = Hand.getHandType(cards_joker_replaced)
        }
        else {
            self.hand_type = Hand.getHandType(cards)
        }
    }


    static func getCardCollectionCounts(_ cards : String) -> CardCollectionCounts {
        let card_count = Hand.getCardCounts(cards)
        var counts = CardCollectionCounts()
        for (_, count) in card_count {
            switch count {
                case 2 :
                    counts.pairs += 1
                case 3 :
                    counts.threes += 1
                case 4 :
                    counts.fours += 1
                case 5 :
                    counts.fives += 1
                default :
                    break
            }
        }

        return counts
    }

    static func getHandType(_ cards : String) -> Int {
        var hand_type : Int
        let card_collection_counts = getCardCollectionCounts(cards)

        if card_collection_counts.fives == 1 {
            hand_type = 7
        }
        else if card_collection_counts.fours == 1 {
            hand_type = 6
        }
        else if card_collection_counts.pairs == 1 && card_collection_counts.threes == 1 {
            hand_type = 5
        }
        else if card_collection_counts.threes == 1 {
            hand_type = 4
        }
        else if card_collection_counts.pairs == 2 {
            hand_type = 3
        }
        else if card_collection_counts.pairs == 1 {
            hand_type = 2
        }
        else {
            hand_type = 1
        }

       return hand_type
    }

    static func < (lhs : Hand, rhs : Hand) -> Bool {
        if lhs.hand_type == rhs.hand_type {
            let rhs_cards = Array(rhs.cards)
            let lhs_cards = Array(lhs.cards)
            for i in 0...4 {
                if lhs_cards[i] != rhs_cards[i] {
                    return card_value[String(lhs_cards[i])]! < card_value[String(rhs_cards[i])]!
                }
            }
        }

        return lhs.hand_type < rhs.hand_type
    }
}

func part1(_ lines : [String]) {
    var hands = [Hand]()

    for line in lines {
        let hand_bid_array = line.components(separatedBy: " ")
        hands.append(Hand(hand_bid_array[0], Int(hand_bid_array[1])!, using_jokers: false))
    }

    var sum = 0
    for (rank, hand) in hands.sorted(by: <).enumerated() {
        sum += hand.bid * (rank + 1)
    }

    print(sum)
}

func part2(_ lines : [String]) {
    var hands = [Hand]()

    Hand.card_value["J"] = 1
    for line in lines {
        let hand_bid_array = line.components(separatedBy: " ")
        hands.append(Hand(hand_bid_array[0], Int(hand_bid_array[1])!, using_jokers: true))
    }

    var sum = 0
    for (rank, hand) in hands.sorted(by: <).enumerated() {
        sum += hand.bid * (rank + 1)
    }

    print(sum)
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

part1(lines)
part2(lines)

