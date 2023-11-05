//
//  ContentView.swift
//  PokeAPI
//
//  Created by norelhoda on 28/10/2023.
//

import SwiftUI

struct HomeView: View {
    @State var salah: Bool = false
    @StateObject var pokimonViewModel: PokimonViewModel = PokimonViewModel()
    var body: some View {
        NavigationView {
            GeometryReader { geomtry in
                VStack {
                    VStack {
                        HStack {
                            Text("Pokedex")
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Text("Mohamed Salah Abd Elhalim Omran, djshkadjas")
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        SearchBar(isRefrehDisabled: $salah, searchText: $pokimonViewModel.query)
                            .padding(.bottom, 20)
                    }
                    .padding()
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 17) {
                            ForEach(pokimonViewModel.pokimonListSalah) { pokimon in
                                let image = pokimon.sprites.other?.officialArtwork.frontDefault ?? pokimon.sprites.frontDefault
                                let color = pokimonViewModel.detectColor(type: pokimon.types[0].type.name)
                                
                                NavigationLink(destination: PokimonDetails(pokemon: pokimon, color: color)) {
                                    PokimonCard(color: color, pokimonName: pokimon.name, image: image, typesELementArray: pokimon.types, isThierAnError: $pokimonViewModel.theirIsAnError)
                                        .frame(width: geomtry.size.width / 2 - 20, height: 150)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
struct SearchBar: View {
    @Binding var isRefrehDisabled: Bool
    @Binding var searchText: String
    var body: some View {
        HStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding(.leading, 8)
                    .frame(height: 35)
                Spacer()
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
