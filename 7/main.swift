import Foundation

struct Hand {
    let cards : String
    let bid : Int
    let hand_type : HandType
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

    enum HandType : Int {
        case five_kind
        case four_kind
        case full_house
        case three_kind
        case two_pair
        case one_pair
        case high_card

        func get() -> Int {
            switch self {
                case .five_kind:
                    return 7
                case .four_kind:
                    return 6
                case .full_house:
                    return 5
                case .three_kind:
                    return 4
                case .two_pair:
                    return 3
                case .one_pair:
                    return 2
                case .high_card:
                    return 1
            }
        }
    }

    init(_ cards : String, _ bid : Int){
        self.cards = cards
        self.bid = bid
        self.hand_type = Hand.getHandType(cards)
    }

    static func getHandType(_ cards : String) -> HandType {
        var hand_type = HandType.high_card
        var card_count = [Character:Int]()
        for card in Array(cards) {
            card_count[card, default: 0] += 1
        }

        var pairs = 0
        var threes = 0
        var fours = 0
        var fives = 0
        let jokers = card_count["J"] ?? 0

        for (_, count) in card_count {
            switch count {
                case 2 :
                    pairs += 1
                case 3 :
                    threes += 1
                case 4 :
                    fours += 1
                case 5 :
                    fives += 1
                default :
                    break
            }
        }
        
        if fives == 1 {
            hand_type = HandType.five_kind
        }
        else if fours == 1 {
            if jokers == 0 {
                hand_type = HandType.four_kind
            }
            else {
                hand_type = HandType.five_kind
            }
        }
        else if pairs == 1 && threes == 1 {
            if jokers == 2 || jokers == 3{
                hand_type = HandType.five_kind
            }
            else {
                hand_type = HandType.full_house
            }
        }
        else if threes == 1 {
            if jokers == 3 || jokers == 1 {
                hand_type = HandType.four_kind
            }
            else {
                hand_type = HandType.three_kind
            }
        }
        else if pairs == 2 {
            if jokers == 2 {
                hand_type = HandType.four_kind
            }
            else if jokers == 1 {
                hand_type = HandType.full_house
            }
            else {
                hand_type = HandType.two_pair
            }
        }
        else if pairs == 1 {
            if jokers == 2 || jokers == 1{
                hand_type = HandType.three_kind
            }
            else {
                hand_type = HandType.one_pair
            }
        }
        else {
            if jokers == 1 {
                hand_type = HandType.one_pair
            }
            else {
                hand_type = HandType.high_card
            }
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

        return lhs.hand_type.get() < rhs.hand_type.get()
    }
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"

if freopen(input_path, "r", stdin) == nil {
    perror(input_path)
    exit(1)
}

// part 1
var hands = [Hand]()
while let line = readLine() {
    let hand_bid_array = line.components(separatedBy: " ")
    hands.append(Hand(hand_bid_array[0], Int(hand_bid_array[1])!))
}

hands.sort(by: <)
var i = 1
var sum = 0
for hand in hands {
    sum += hand.bid * i
    i += 1
}

print(sum)
