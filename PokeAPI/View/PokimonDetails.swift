//
//  PokimonDetails.swift
//  PokeAPI
//
//  Created by norelhoda on 02/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokimonDetails: View {
    var pokemon: Pokimon
    var color: Color = .green
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WebImage(url: URL(string: pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault))
                        .placeholder{
                            if let image = PokimonDataManager.shared().retrieveImageFromRealm(url: pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                            }
                            
                        }
                        .resizable()
                        .indicator(.activity)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    Text(pokemon.name)
                        .font(.largeTitle)
                    
                    Text("Weight: \(pokemon.weight) kg")
                    Text("Height: \(pokemon.height) m")
                    
                    Text("Types:")
                        .font(.headline)
                    HStack {
                        ForEach(pokemon.types) { row in
                            Text(row.type.name)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Abilities:")
                        .font(.headline)
                    HStack {
                        ForEach(pokemon.abilities) { ability in
                            Text(ability.ability.name)
                                .padding(8)
                                .background(Color.red)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("Moves:")
                        .font(.headline)
                    VStack(alignment: .leading) {
                        ForEach(pokemon.moves) { move in
                            Text(move.move.name)
                                .bold()
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Pokemon Details", displayMode: .inline)
        }
    }
}

