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

struct CardCollectionCounts {
    var pairs = 0
    var threes = 0
    var fives = 0
    var fours = 0
}

struct Hand {
    let cards : String
    let bid : Int
    let hand_rank : HandRank
    enum HandRank : Int {
        case five_kind = 7
        case four_kind = 6
        case full_house = 5
        case three_kind = 4
        case two_pair = 3
        case one_pair = 2
        case high_card = 1
    }

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

    static func getHandRank(_ cards : String) -> HandRank {
        let hand_rank : HandRank
        let card_collection_counts = getCardCollectionCounts(cards)

        if card_collection_counts.fives == 1 {
            hand_rank = HandRank.five_kind
        }
        else if card_collection_counts.fours == 1 {
            hand_rank = HandRank.four_kind
        }
        else if card_collection_counts.pairs == 1 && card_collection_counts.threes == 1 {
            hand_rank = HandRank.full_house
        }
        else if card_collection_counts.threes == 1 {
            hand_rank = HandRank.three_kind
        }
        else if card_collection_counts.pairs == 2 {
            hand_rank = HandRank.two_pair
        }
        else if card_collection_counts.pairs == 1 {
            hand_rank = HandRank.one_pair
        }
        else {
            hand_rank = HandRank.high_card
        }

       return hand_rank
    }

    static func < (lhs : Hand, rhs : Hand) -> Bool {
        if lhs.hand_rank.rawValue == rhs.hand_rank.rawValue {
            let rhs_cards = rhs.cards.map{card_value[String($0)]!}
            let lhs_cards = lhs.cards.map{card_value[String($0)]!}
            return lhs_cards < rhs_cards
        }

        return lhs.hand_rank.rawValue < rhs.hand_rank.rawValue
        //        if lhs.hand_rank.rawValue == rhs.hand_rank.rawValue {
        //     let rhs_cards = Array(rhs.cards)
        //     let lhs_cards = Array(lhs.cards)
        //     for i in 0...4 {
        //         if lhs_cards[i] != rhs_cards[i] {
        //             return card_value[String(lhs_cards[i])]! < card_value[String(rhs_cards[i])]!
        //         }
        //     }
        // }

        // return lhs.hand_rank.rawValue < rhs.hand_rank.rawValue
    } 
}

func part1(_ lines : [String]) {
    var hands = [Hand]()

    for line in lines {
        let hand_bid_array = line.components(separatedBy: " ")
        let new_hand = Hand(hand_bid_array[0], Int(hand_bid_array[1])!, using_jokers: false) 
        hands.append(new_hand)
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
        let new_hand = Hand(hand_bid_array[0], Int(hand_bid_array[1])!, using_jokers: true) 
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

part1(lines)
part2(lines)

