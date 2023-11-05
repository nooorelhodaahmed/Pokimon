
//
//  Persistence.swift
//  PokeAPI
//
//  Created by norelhoda on 28/10/2023.
//
import Foundation
import RealmSwift
import UIKit

class PokimonDataManager {
    private init() {}
    
    private static let sharedInstance = PokimonDataManager()
    private let realm = try! Realm()
    
    static func shared() -> PokimonDataManager {
        return PokimonDataManager.sharedInstance
    }
    // MARK: - Convert from Pokimon to Realm
    
    func convertToRealmModel(pokimon: Pokimon, completion: @escaping (PokimonRealm?) -> Void) {
        let pokimonRealm = PokimonRealm()
        pokimonRealm.abilities.append(objectsIn: pokimon.abilities.map { convertToRealmModel(ability: $0) })
        pokimonRealm.height = pokimon.height
        pokimonRealm.id = pokimon.id
        pokimonRealm.moves.append(objectsIn: pokimon.moves.map { convertToRealmModel(move: $0) })
        pokimonRealm.name = pokimon.name
        pokimonRealm.order = pokimon.order
        pokimonRealm.species = convertToRealmModel(species: pokimon.species)
        convertToRealmModel(sprites: pokimon.sprites) { spritesRealm in
            if let spritesR = spritesRealm {
                pokimonRealm.sprites = spritesR
            }
            pokimonRealm.types.append(objectsIn: pokimon.types.map { self.convertToRealmModel(typeElement: $0) })
            pokimonRealm.weight = pokimon.weight
            
            completion(pokimonRealm)
        }
    }
    
    
    func convertToRealmModel(ability: Ability) -> AbilityRealm {
        let abilityRealm = AbilityRealm()
        abilityRealm.ability = convertToRealmModel(species: ability.ability)
        abilityRealm.id = ability.id
        return abilityRealm
    }
    
    func convertToRealmModel(species: Species) -> SpeciesRealm {
        let speciesRealm = SpeciesRealm()
        speciesRealm.name = species.name
        return speciesRealm
    }
    
    func convertToRealmModel(move: Move) -> MoveRealm {
        let moveRealm = MoveRealm()
        moveRealm.move = convertToRealmModel(species: move.move)
        return moveRealm
    }
    
    func convertToRealmModel(sprites: Sprites, completion: @escaping (SpritesRealm?) -> Void) {
        let spritesRealm = SpritesRealm()
        spritesRealm.frontDefault = sprites.frontDefault
        cacheImageAsync(urlString: sprites.frontDefault) { data in
            self.saveImageDataInRealm(url: sprites.frontDefault, data: data)
            self.convertToRealmModel(other: sprites.other) { otherRealm in
                spritesRealm.other = otherRealm
                completion(spritesRealm)
            }
        }
    }
    
    func convertToRealmModel(officialArtwork: OfficialArtwork, completion: @escaping (OfficialArtworkRealm?) -> Void) {
        let officialArtworkRealm = OfficialArtworkRealm()
        officialArtworkRealm.frontDefault = officialArtwork.frontDefault
        cacheImageAsync(urlString: officialArtwork.frontDefault) { data in
            self.saveImageDataInRealm(url: officialArtwork.frontDefault, data: data)
            completion(officialArtworkRealm)
        }
    }
    
    func saveImageDataInRealm(url: String?, data: Data?) {
        guard let url = url, let data = data else { return }
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                try realm.write {
                    if realm.object(ofType: CachedImageRealm.self, forPrimaryKey: url) == nil {
                        let cachedImage = CachedImageRealm()
                        cachedImage.url = url
                        cachedImage.imageData = data
                        realm.add(cachedImage)
                    }
                }
            } catch {
                print("Error saving image data in Realm: \(error)")
            }
        }
    }
    
    
    func convertToRealmModel(other: Other?, completion: @escaping (OtherRealm?) -> Void) {
        guard let other = other else { completion(nil); return }
        let otherRealm = OtherRealm()
        cacheImageAsync(urlString: other.officialArtwork.frontDefault) { data in
            let officialArtworkRealm = OfficialArtworkRealm()
            officialArtworkRealm.frontDefault = other.officialArtwork.frontDefault
            otherRealm.officialArtwork = officialArtworkRealm
            self.saveImageDataInRealm(url: other.officialArtwork.frontDefault, data: data)
            completion(otherRealm)
        }
    }
    
    
    func cacheImageAsync(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil); return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let imageData = data {
                if let compressedImageData = UIImage(data: imageData)?.jpeg(.lowest) {
                    DispatchQueue.main.async {
                        completion(compressedImageData)
                    }
                } else {
                    print("Error compressing the image.")
                    completion(nil)
                }
            } else if let error = error {
                print("Error downloading the image: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func convertToRealmModel(typeElement: TypeElement) -> TypeElementRealm {
        let typeElementRealm = TypeElementRealm()
        typeElementRealm.id = typeElement.id
        typeElementRealm.type = convertToRealmModel(species: typeElement.type)
        return typeElementRealm
    }
    
    func saveInRealm(pokimon: Pokimon) {
        convertToRealmModel(pokimon: pokimon) { [self] pokimonRealm in
            guard let pokimonRealm = pokimonRealm else { return }
            try! realm.write {
                if realm.object(ofType: PokimonRealm.self, forPrimaryKey: pokimonRealm.id) == nil {
                    realm.add(pokimonRealm)
                }
            }
        }
    }
    
    
    
    // MARK: - Convert from realm to Pokimon
    
    func convertToCodableModel(pokimonRealm: PokimonRealm) -> Pokimon {
        return Pokimon(
            abilities: pokimonRealm.abilities.map { convertToModel(abilityRealm: $0) },
            height: pokimonRealm.height,
            id: pokimonRealm.id,
            moves: pokimonRealm.moves.map { convertToModel(moveRealm: $0) },
            name: pokimonRealm.name,
            order: pokimonRealm.order,
            species: convertToModel(speciesRealm: pokimonRealm.species!),
            sprites: convertToModel(spritesRealm: pokimonRealm.sprites!),
            types: pokimonRealm.types.map { convertToModel(typeElementRealm: $0) },
            weight: pokimonRealm.weight
        )
    }
    
    
    func convertToModel(abilityRealm: AbilityRealm) -> Ability {
        return Ability(ability: convertToModel(speciesRealm: abilityRealm.ability!), id: abilityRealm.id)
    }
    
    func convertToModel(speciesRealm: SpeciesRealm) -> Species {
        return Species(name: speciesRealm.name)
    }
    
    func convertToModel(moveRealm: MoveRealm) -> Move {
        return Move(move: convertToModel(speciesRealm: moveRealm.move!))
    }
    
    func convertToModel(spritesRealm: SpritesRealm) -> Sprites {
        return Sprites(frontDefault: spritesRealm.frontDefault!, other: convertToModel(otherRealm: spritesRealm.other))
    }
    
    func convertToModel(otherRealm: OtherRealm?) -> Other? {
        guard let otherRealm = otherRealm else { return nil }
        return Other(officialArtwork: convertToModel(officialArtworkRealm: otherRealm.officialArtwork!))
    }
    
    func convertToModel(officialArtworkRealm: OfficialArtworkRealm) -> OfficialArtwork {
        return OfficialArtwork(frontDefault: officialArtworkRealm.frontDefault!)
    }
    
    func convertToModel(typeElementRealm: TypeElementRealm) -> TypeElement {
        return TypeElement(id: typeElementRealm.id, type: convertToModel(speciesRealm: typeElementRealm.type!))
    }
    
    func retrieveImageFromRealm(url: String?) -> UIImage? {
        guard let url = url else { return nil }
        do {
            let realm = try Realm()
            if let cachedImage = realm.object(ofType: CachedImageRealm.self, forPrimaryKey: url),
               let image = UIImage(data: cachedImage.imageData) {
                return image
            } else {
                return nil
            }
        } catch {
            print("Error retrieving image data from Realm: \(error)")
            return nil
        }
    }
    
    func getAllPokimonFromRealm() -> [Pokimon] {
        let pokimonRealmResults = realm.objects(PokimonRealm.self)
        return pokimonRealmResults.map { convertToCodableModel(pokimonRealm: $0) }
    }
 
    func returnDataBaseURL() -> String {
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            return ("Realm database URL: \(realmURL)")
        }
        return "Couldn't Find the Database"
    }
    
}




