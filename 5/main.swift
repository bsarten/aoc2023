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

struct Recipe
{
    var source : String 
    var destination : String
    var source_range : ClosedRange<UInt64>
    var destination_range : ClosedRange<UInt64>

    init(_ source : String, _ destination : String, _ source_range : ClosedRange<UInt64>, _ destination_range : ClosedRange<UInt64>) {
        self.destination_range = destination_range
        self.source = source
        self.destination = destination
        self.source_range = source_range
    }
}

struct Recipes
{
    var seeds : [UInt64]
    var destination_to_recipe = [String : [Recipe]]()

    init(_ seeds : [UInt64]){
        self.seeds = seeds
    }
}

func find_location(_ recipes : inout Recipes, _ recipe_name : String, _ number : UInt64) -> UInt64 {
    if recipe_name == "location" {
        return number
    }

    for check_recipe in recipes.destination_to_recipe[recipe_name]! {
        if check_recipe.source_range.contains(number) {
            let destination_number = check_recipe.destination_range.first! + number - check_recipe.source_range.first!
            return find_location(&recipes, check_recipe.destination, destination_number)
        }
    }

    return find_location(&recipes, recipes.destination_to_recipe[recipe_name]![0].destination, number)
}

func find_location(_ recipes : inout Recipes, _ recipe_name : String, _ number_range : ClosedRange<UInt64>) -> UInt64 {
    if recipe_name == "location" {
        return number_range.first!
    }

    var min_location : UInt64? = nil

    for check_recipe in recipes.destination_to_recipe[recipe_name]! {
        if let intersection = check_recipe.source_range.intersection(number_range) {
            let destination_range_begin = check_recipe.destination_range.first! + intersection.first! - check_recipe.source_range.first!
            let destination_range_end = destination_range_begin + UInt64(intersection.count) - 1
            let location = find_location(&recipes, check_recipe.destination, destination_range_begin...destination_range_end)
            min_location = Swift.min(min_location ?? location, location)
        }
    }

    if min_location == nil {
        let location = find_location(&recipes, recipes.destination_to_recipe[recipe_name]![0].destination, number_range)
        min_location = Swift.min(min_location ?? location, location)
    }
    return min_location!
}

let input_path = Process().currentDirectoryURL!.path + "/input.txt"

if freopen(input_path, "r", stdin) == nil {
    perror(input_path)
    exit(1)
}

var line = readLine()!
var seeds = line.components(separatedBy: ": ")[1].components(separatedBy: " ").map{UInt64($0)!}
var recipes = Recipes(seeds)
_ = readLine()
while let header_line = readLine() {
    let search = #/^(.*)-to-(.*) map:$/#
    let matches = header_line.wholeMatch(of:search)?.output
    let source = String(matches!.1)
    let destination = String(matches!.2)
    recipes.destination_to_recipe[source] = [Recipe]()

    var minimum_source : UInt64?
    var maximum_source : UInt64?
    while let transform_line = readLine() {
        if transform_line.isEmpty {
            break
        }
        let recipe_array = transform_line.components(separatedBy: " ").map{UInt64($0)!}
        let destination_range = recipe_array[0]...recipe_array[0] + recipe_array[2] - 1
        let source_range = recipe_array[1]...recipe_array[1] + recipe_array[2] - 1 
        minimum_source = Swift.min(minimum_source ?? source_range.first!, source_range.first!)
        maximum_source = Swift.max(maximum_source ?? source_range.last!, source_range.last!)

        recipes.destination_to_recipe[source]!.append(Recipe(source, destination, source_range, destination_range))
    }
    if minimum_source != 0 {
        recipes.destination_to_recipe[source]!.append(Recipe(source, destination, 0...minimum_source!-1, 0...minimum_source!-1))
    }
    if maximum_source != 0 && maximum_source != UInt64.max{
        recipes.destination_to_recipe[source]!.append(Recipe(source, destination, maximum_source!+1...UInt64.max, maximum_source!+1...UInt64.max))
    }
}

// part 1
var min_location : UInt64? = nil
for seed in recipes.seeds {
    let location = find_location(&recipes, "seed", seed)
    min_location = Swift.min(min_location ?? location, location)
}

print(min_location ?? "nil")

min_location = nil

for i in 0..<recipes.seeds.count where i % 2 == 0 {
    let seed_range = recipes.seeds[i]...(recipes.seeds[i+1] + recipes.seeds[i] - 1)
    let location = find_location(&recipes, "seed", seed_range)
    min_location = Swift.min(min_location ?? location, location)
}

print(min_location ?? "nil")


