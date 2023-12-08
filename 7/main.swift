import Foundation

extension Array where Element: Comparable{
    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        for index in 0..<lhs.count {
            if rhs.count-1 < index {
                return true
            }

            if (lhs[index] != rhs[index]) {
                return lhs[index] < rhs[index]
            }
        }
        return false
    }
}

struct Hand {
    let cards : String
    let bid : Int
    let hand_rank : HandRank

    // each place contains the number of card groups
    // from five-of-a-kind to four-of-a-kind...down to 1-of-a-kind
    enum HandRank : Int {
        case five_kind = 10000
        case four_kind = 01001
        case full_house = 00110
        case three_kind = 00102
        case two_pair = 00021
        case one_pair = 00013
        case high_card = 00005
    }

    static var card_value = [ "2" : 2, "3" : 3, "4" : 4, "5" : 5,
        "6" : 6, "7" : 7, "8" : 8, "9" : 9, "T" : 10, "J" : 11,
        "Q" : 12, "K" : 13, "A" : 14 
    ]

    static func getCardCounts(_ cards : String) -> [Character:Int] {
        return Array(cards).reduce(into: [:]){$0[$1, default: 0] += 1}
    }

    init(_ cards : String, _ bid : Int, using_jokers : Bool) {
        self.cards = cards
        self.bid = bid
        
        let rank_cards : String

        if using_jokers {
            let card_count = Hand.getCardCounts(cards) 
            let max_card = card_count.max(by: {($0.key == "J" ? 0 : $0.value) < ($1.key == "J" ? 0 : $1.value)})
            rank_cards = String(cards.map{$0 == "J" ? max_card!.key : $0})
        }
        else {
            rank_cards = cards
        }

        self.hand_rank = Hand.getHandRank(rank_cards)
    }

    static func getCardCollectionCounts(_ cards : String) -> [Int] {
        var counts = [0, 0, 0, 0, 0]
        let card_count = Hand.getCardCounts(cards)
        for (_, count) in card_count {
            counts[count - 1] += 1
        }

        return counts
    }

    static func getHandRank(_ cards : String) -> HandRank {
        let card_collection_counts = getCardCollectionCounts(cards)
        let counts = Int(card_collection_counts.reversed().reduce(""){$0 + String($1)})!
        return HandRank(rawValue: counts)!
    }

    static func < (lhs : Hand, rhs : Hand) -> Bool {
        if lhs.hand_rank.rawValue == rhs.hand_rank.rawValue {
            let rhs_cards = rhs.cards.map{card_value[String($0)]!}
            let lhs_cards = lhs.cards.map{card_value[String($0)]!}
            return lhs_cards < rhs_cards
        }

        return lhs.hand_rank.rawValue < rhs.hand_rank.rawValue
    } 
}

func do_part(_ lines : [String], using_jokers: Bool) {
    var hands = [Hand]()

    Hand.card_value["J"] = using_jokers ? 1 : 11

    for line in lines {
        let hand_bid_array = line.components(separatedBy: " ")
        let new_hand = Hand(hand_bid_array[0], Int(hand_bid_array[1])!, using_jokers: using_jokers) 
        hands.append(new_hand)
    }

    var sum = 0
    for (rank, hand) in hands.sorted(by: <).enumerated() {
        sum += hand.bid * (rank + 1)
    }

    print(sum)
}

let input_path = URL(fileURLWithPath: Process().currentDirectoryURL!.path + "/input.txt")
let lines = try String(contentsOf: input_path).components(separatedBy:"\n").filter{!$0.isEmpty}

do_part(lines, using_jokers: false)
do_part(lines, using_jokers: true)

