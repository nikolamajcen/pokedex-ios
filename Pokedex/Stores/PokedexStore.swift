//
//  PokedexStore.swift
//  Pokedex
//
//  Created by Nikola Majcen on 05/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift

class PokedexStore: NSObject {
    
    // var alamofireManager: Alamofire.Manager?
    
    override init() {
        super.init()
        configurateRequestTimeout()
    }
    
    func fetchPokemons(completion: ([Pokemon]!) -> Void) -> Void {
        
        let pokemons: [Pokemon]
        if UserDefaultsManager.gameMode == true {
            let manager = DatabaseManager()
            pokemons = manager.getAllPokemons()
        } else {
            let filePath = Bundle.main.path(forResource: "pokedex", ofType: "json")
            let data = NSData(contentsOfFile: filePath!)
            let value = String(data: data! as Data, encoding: String.Encoding.utf8)
            pokemons = Mapper<Pokemon>().mapArray(JSONString: value!)!
        }
        completion(pokemons)

        // Can be removed
        /*
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon/?limit=151&offset=0")
            .responseJSON { response in
                
                if let error = self.evaluateResponse(response) {
                    completion(nil, error)
                } else {
                    let pokemons = Mapper<Pokemon>().mapArray(response.result.value!["results"])
                    completion(pokemons, nil)
                }
        }
        */
    }
    
    func fetchPokemonDetails(id: Int, completion: @escaping (Pokemon?, NSError?) -> Void) -> Void {
        // alamofireManager!
        Alamofire
            .request("https://pokeapi.co/api/v2/pokemon/\(id)/", method: .get)
            .responseJSON { (response) in
                
                if let error = self.evaluateResponse(response: response) {
                    completion(nil, error)
                } else {
                    let pokemon = Mapper<Pokemon>().map(JSONObject: response.result.value)
                    completion(pokemon, nil)
                }
        }
    }
    
    func fetchPokemonSpecies(id: Int, completion: @escaping (PokemonSpecies?, NSError?) -> Void) -> Void {
        // alamofireManager!
        Alamofire
            .request("https://pokeapi.co/api/v2/pokemon-species/\(id)/", method: .get)
            .responseJSON { (response) in

                if let error = self.evaluateResponse(response: response) {
                    completion(nil, error)
                } else {
                    let pokemonSpecies = Mapper<PokemonSpecies>().map(JSONObject: response.result.value)
                    completion(pokemonSpecies, nil)
                }
        }
    }
    
    func fetchPokemonEvolutionChain(id: Int, completion: @escaping (PokemonEvolutionChain?, NSError?) -> Void) -> Void {
        // alamofireManager!
        Alamofire
            .request("https://pokeapi.co/api/v2/evolution-chain/\(id)/", method: .get)
            .responseJSON { (response) in
                
                if let error = self.evaluateResponse(response: response) {
                    completion(nil, error)
                } else {
                    let pokemonEvolutionChain = Mapper<PokemonEvolutionChain>().map(JSONObject: response.result.value)
                    completion(pokemonEvolutionChain, nil)
                }
        }
    }
    
    private func configurateRequestTimeout() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        // self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    private func evaluateResponse(response: DataResponse<Any>) -> NSError! {
        if response.response == nil {
            return NSError(domain: "No network connection.", code: 0, userInfo: nil)
        }
        
        if response.result.isFailure {
            return NSError(domain: "Bad request.", code: (response.response?.statusCode)!, userInfo: nil)
        }
        
        if response.result.value == nil {
            return NSError(domain: "No data.", code: (response.response?.statusCode)!, userInfo: nil)
        }
        return nil
    }
}
