//
//  PokemonEvolution.swift
//  Pokedex
//
//  Created by Nikola Majcen on 07/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonEvolution: NSObject, Mappable {
    
    var identifier: Int?

    private var name: String?
    private var url: NSURL?
    
    var evolutionChain: [PokemonEvolution]?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        evolutionChain = [PokemonEvolution]()
        
        self.name <- map["species.name"]
        self.url <- map["species.url"]
        evolutionChain!.append(self)
        
        print("Element list:")
        for evolution: PokemonEvolution in evolutionChain! {
            print(evolution.name!)
        }
        
        var counter = 1
        while counter <= 2 {
            var evolves_to = "evolves_to.0"
            if counter > 1 {
                evolves_to = evolves_to + "." + evolves_to
            }
            
            print(evolves_to)
            
            self.name <- map[evolves_to + ".species.name"]
            self.url <- (map[evolves_to + ".species.url"], URLTransform())
            
            print(self.name)
            
            if self.name == nil || self.url == nil {
                break
            }
            
            evolutionChain!.append(self)
            
            print("Element list:")
            for evolution: PokemonEvolution in evolutionChain! {
                print(evolution.name!)
            }
            
            counter = counter.advancedBy(1)
        }
        
        print(evolutionChain!.count)
        for evolution: PokemonEvolution in evolutionChain! {
            print(evolution.name!)
        }
    }
    
    func addEvolutionToChain() {
        
    }
}