//
//  NetwrokManager.swift
//  PokeAPI
//
//  Created by norelhoda on 29/10/2023.
//



import UIKit

typealias Parameters = [String: String]

final class AuthService {
    
    static let shared = AuthService()
    
    public enum Endpoints {
        
        static let base = "https://pokeapi.co/api/v2/pokemon"
        case pokomin
        case pokimonDetails(String)
        
        var stringValue: String {
            switch self {
            case .pokomin:
                return Endpoints.base
            case .pokimonDetails(let url):
                return url
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func getPokimon(url:String,completion: @escaping (Result<PokimonData,Error>) -> Void) {
        print()
        
        let task = URLSession.shared.dataTask(with: URL(string: url) ?? Endpoints.pokomin.url) { data, response, error in
            print(data)
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(PokimonData.self, from: data)
                print(result)
                completion(.success(result))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getPokimonDetails(url:String,completion: @escaping (Result<Pokimon,Error>) -> Void) {
        print()
        let url = Endpoints.pokimonDetails(url).url
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print(data)
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Pokimon.self, from: data)
                print(result)
                completion(.success(result))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
