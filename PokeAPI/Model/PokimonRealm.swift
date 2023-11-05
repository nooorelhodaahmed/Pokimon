//
//  PokimonRealm.swift
//  PokiApp2
//
//  Created by norelhoda on 29/10/2023.
//

import Foundation
import RealmSwift

class PokimonRealm: Object{
    @Persisted var abilities: List<AbilityRealm>
    @Persisted var height: Int
    @Persisted(primaryKey: true) var id: Int
    @Persisted var moves: List<MoveRealm>
    @Persisted var name: String
    @Persisted var order: Int
    @Persisted var species: SpeciesRealm?
    @Persisted var sprites: SpritesRealm?
    @Persisted var types: List<TypeElementRealm>
    @Persisted var weight: Int
}

class AbilityRealm: EmbeddedObject{
    @Persisted var ability: SpeciesRealm?
    @Persisted var id: Int
}

class SpeciesRealm: EmbeddedObject{
    @Persisted var name: String
}

class MoveRealm: EmbeddedObject{
    @Persisted var move: SpeciesRealm?
}


class SpritesRealm: EmbeddedObject {
    @Persisted var frontDefault: String?
    @Persisted var other: OtherRealm?
}

class OfficialArtworkRealm: EmbeddedObject{
    @Persisted var frontDefault: String?
}

class OtherRealm: EmbeddedObject {
    @Persisted var officialArtwork: OfficialArtworkRealm?
}

class TypeElementRealm: EmbeddedObject {
    @Persisted var id: Int
    @Persisted var type: SpeciesRealm?
}

class CachedImageRealm: Object {
    @Persisted(primaryKey: true) var url: String
    @Persisted var imageData: Data
}

