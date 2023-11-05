//
//  PokimonCrad.swift
//  PokeAPI
//
//  Created by norelhoda on 29/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokimonCard: View {
    
    var color: Color = .green
    var pokimonName: String
    var image : String
    var typesELementArray: [TypeElement] = [TypeElement]()
    @Binding var isThierAnError: Bool
    
    var body: some View {
        GeometryReader { geomtry in
            ZStack {
                color
                VStack {
                    HStack {
                        Text(pokimonName)
                            .padding()
                            .foregroundStyle(.white)
                            .font(.title2)
                        Spacer()
                    }
                    HStack {
                        VStack (alignment: .leading, spacing: 5) {
                            ForEach(typesELementArray) { pokimon in
                                HStack(spacing: 5) {
                                    Image(systemName: "circle")
                                        .foregroundColor(.white)
                                    Text(pokimon.type.name)
                                        .foregroundStyle(.white)
                                        .padding(.trailing, 3)
                                }
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        
                        WebImage(url: URL(string: image))
                            .placeholder{
                                if let image = PokimonDataManager.shared().retrieveImageFromRealm(url: image) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .resizable()
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: geomtry.size.width - 100 ,height: 70)
                    }
                }
            }
            .cornerRadius(20)
        }
    }
}
