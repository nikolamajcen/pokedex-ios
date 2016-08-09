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
    
    var alamofireManager: Alamofire.Manager?
    
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
            let filePath = NSBundle.mainBundle().pathForResource("pokedex", ofType: "json")
            let data = NSData(contentsOfFile: filePath!)
            let value = String(data: data!, encoding: NSUTF8StringEncoding)
            pokemons = Mapper<Pokemon>().mapArray(value!)!
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
    
    func fetchPokemonDetails(id: Int, completion: (Pokemon!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon/\(id)/")
            .responseJSON { (response) in
                
                if let error = self.evaluateResponse(response) {
                    completion(nil, error)
                } else {
                    let pokemon = Mapper<Pokemon>().map(response.result.value)
                    completion(pokemon, nil)
                }
        }
    }
    
    func fetchPokemonSpecies(id: Int, completion: (PokemonSpecies!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon-species/\(id)/")
            .responseJSON { (response) in

                if let error = self.evaluateResponse(response) {
                    completion(nil, error)
                } else {
                    let pokemonSpecies = Mapper<PokemonSpecies>().map(response.result.value)
                    completion(pokemonSpecies, nil)
                }
        }
    }
    
    func fetchPokemonEvolutionChain(id: Int, completion: (PokemonEvolutionChain!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/evolution-chain/\(id)/")
            .responseJSON { (response) in
                
                if let error = self.evaluateResponse(response) {
                    completion(nil, error)
                } else {
                    let pokemonEvolutionChain = Mapper<PokemonEvolutionChain>().map(response.result.value)
                    completion(pokemonEvolutionChain, nil)
                }
        }
    }
    
    private func configurateRequestTimeout() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 15
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    private func evaluateResponse(response: Response<AnyObject, NSError>) -> NSError! {
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