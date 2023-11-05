import Foundation

struct Pokimon: Codable, Identifiable {
    var abilities: [Ability]
    var height: Int
    var id: Int
    var moves: [Move]
    var name: String
    var order: Int
    var species: Species
    var sprites: Sprites
    var types: [TypeElement]
    var weight: Int

    enum CodingKeys: String, CodingKey {
        case abilities = "abilities"
        case height = "height"
        case id = "id"
        case moves = "moves"
        case name = "name"
        case order = "order"
        case species = "species"
        case sprites = "sprites"
        case types = "types"
        case weight = "weight"
    }
}

// MARK: - Ability
struct Ability: Codable, Identifiable {
    var ability: Species
    var id: Int

    enum CodingKeys: String, CodingKey {
        case ability = "ability"
        case id = "slot"
    }
}

// MARK: - Species
struct Species: Codable {
    var name: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}



// MARK: - Move
struct Move: Codable, Identifiable{
    var move: Species
    var id = UUID()

    enum CodingKeys: String, CodingKey {
        case move = "move"
    }
}

// MARK: - Sprites
struct Sprites: Codable {
    var frontDefault: String
    var other: Other?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other = "other"
    }
}


// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    var frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Other
struct Other: Codable {

    var officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}


// MARK: - TypeElement
struct TypeElement: Codable, Identifiable {
    var id: Int
    var type: Species

    enum CodingKeys: String, CodingKey {
        case id = "slot"
        case type = "type"
    }
}


