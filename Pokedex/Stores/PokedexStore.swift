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

class PokedexStore: NSObject {
    
    var alamofireManager: Alamofire.Manager?
    
    override init() {
        super.init()
        self.configurateRequestTimeout()
    }
    
    private func configurateRequestTimeout() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 5
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    func fetchPokemons(completion: ([Pokemon]!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon/?limit=151&offset=0")
            .responseJSON { response in
                if response.response == nil {
                    completion(nil,
                        NSError(domain: "No network connection.",
                            code: 0,
                            userInfo: nil))
                    return
                }
                
                guard response.result.isSuccess else {
                    completion(nil,
                        NSError(domain: "Bad request.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                guard let value = response.result.value!["results"] else {
                    completion(nil,
                        NSError(domain: "No data.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                let pokemons = Mapper<Pokemon>().mapArray(value)
                completion(pokemons, nil)
        }
    }
    
    func fetchPokemonDetails(id: Int, completion: (Pokemon!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon/\(id)/")
            .responseJSON { (response) in
                if response.response == nil {
                    completion(nil,
                        NSError(domain: "No network connection.",
                            code: 0,
                            userInfo: nil))
                    return
                }
                
                guard response.result.isSuccess else {
                    completion(nil,
                        NSError(domain: "Bad request.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                guard let value = response.result.value else {
                    completion(nil,
                        NSError(domain: "No data.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                                
                let pokemon = Mapper<Pokemon>().map(value)
                completion(pokemon, nil)
        }
    }
    
    func fetchPokemonAdditionInfo(id: Int, completion: (PokemonSpecies!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/pokemon-species/\(id)/")
            .responseJSON { (response) in
                if response.response == nil {
                    completion(nil,
                        NSError(domain: "No network connection.",
                            code: 0,
                            userInfo: nil))
                    return
                }
                
                guard response.result.isSuccess else {
                    completion(nil,
                        NSError(domain: "Bad request.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                guard let value = response.result.value else {
                    completion(nil,
                        NSError(domain: "No data.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                let pokemonSpecies = Mapper<PokemonSpecies>().map(value)
                completion(pokemonSpecies, nil)
        }
    }
    
    func fetchPokemonEvolutionChain(id: Int, completion: (PokemonEvolutionChain!, NSError!) -> Void) -> Void {
        alamofireManager!
            .request(.GET, "https://pokeapi.co/api/v2/evolution-chain/\(id)/")
            .responseJSON { (response) in
                if response.response == nil {
                    completion(nil,
                        NSError(domain: "No network connection.",
                            code: 0,
                            userInfo: nil))
                    return
                }
                
                guard response.result.isSuccess else {
                    completion(nil,
                        NSError(domain: "Bad request.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                guard let value = response.result.value else {
                    completion(nil,
                        NSError(domain: "No data.",
                            code: (response.response?.statusCode)!,
                            userInfo: nil))
                    return
                }
                
                let pokemonEvolutionChain = Mapper<PokemonEvolutionChain>().map(value)
                completion(pokemonEvolutionChain, nil)
        }
    }}