//
//  PikomonViewModel.swift
//  PokeAPI
//
//  Created by norelhoda on 29/10/2023.
//

import Foundation
import SwiftUI
import UIKit
import Combine

class PokimonViewModel: ObservableObject {
    var searchQuery: String = ""
    var listOfUrl: [String] = [String]()
    var mainDataModel: PokimonData?
    var pokimonData: [Pokimon] = [Pokimon]()
    private var cancellables: Set<AnyCancellable> = []
    var totalPages = 0
    @Published var pokimonListSalah: [Pokimon] = [Pokimon]()
    @Published var query: String = ""
    @Published var theirIsAnError: Bool = false
    @Published var pokimons : [PokimonData] = []
    @Published var page : Int = 1
    
    init() {
        print(PokimonDataManager.shared().returnDataBaseURL())
        getPokimonData()
        searchPokimonData()
    }
    
    func getPokimonData(){
        AuthService.shared.getPokimon(url: Constants.baseUrl) { result in
            switch result {
            case .success(let response):
                // self.totalPages = response.totalPages
                self.mainDataModel = response
                self.convertToPokimon(pokimonData: response)
                
            case .failure(let error):
                self.theirIsAnError = true
                let pokimonList = PokimonDataManager.shared().getAllPokimonFromRealm()
                DispatchQueue.main.async {
                    self.pokimonData = pokimonList
                    self.pokimonListSalah = pokimonList
                }
                print(error.localizedDescription)
                break
            }
        }
    }
    
    
    func convertToPokimon(pokimonData: PokimonData) {
        for pokimon in pokimonData.results {
            self.listOfUrl.append(pokimon.url)
        }
        self.getPokimon(url: listOfUrl)
    }
    
    func getPokimon(url: [String]){
        for i in listOfUrl {
            AuthService.shared.getPokimonDetails(url: i) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.pokimonData.append(response)
                        self.pokimonListSalah.append(response)
                    }
                    PokimonDataManager.shared().saveInRealm(pokimon: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    func searchPokimonData() {
        $query
            .debounce(for: 0.5, scheduler: DispatchQueue.main) // Add debounce to avoid rapid updates
            .removeDuplicates()
            .sink { [weak self] newQuery in
                withAnimation {
                    if newQuery.isEmpty {
                        self?.pokimonListSalah = self?.pokimonData ?? []
                    } else {
                        self?.pokimonListSalah = self?.pokimonData.filter { pokimon in
                            return pokimon.name.lowercased().contains(newQuery.lowercased())
                        } ?? []
                    }
                }
            }
            .store(in: &cancellables)
    }
    func detectColor(type: String) -> Color {
        switch type.lowercased() {
        case "grass":
            return .green
        case "water":
            return .blue
        case "fire":
            return .orange
        case "bug":
            return .brown
        case "normal":
            return .gray
        default:
            let randomRed = Double.random(in: 0...1)
            let randomGreen = Double.random(in: 0...1)
            let randomBlue = Double.random(in: 0...1)
            return Color(red: randomRed, green: randomGreen, blue: randomBlue)
        }
    }
}

