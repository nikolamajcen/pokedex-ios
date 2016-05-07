//
//  PokemonSpecies.swift
//  Pokedex
//
//  Created by Nikola Majcen on 02/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonSpecies: NSObject, Mappable {
    
    private var descriptions: [PokemonDescription]?
    
    var pokemonDescription: PokemonDescription?
    var pokemonEvolutionChainId: Int?
    var pokemonEvolutionChainUrl: NSURL?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.descriptions <- map["flavor_text_entries"]
        self.setEnglishDescriptionDefault()
        
        self.pokemonEvolutionChainUrl <- (map["evolution_chain.url"], URLTransform())
        self.pokemonEvolutionChainId = Int((self.pokemonEvolutionChainUrl?.absoluteURL.lastPathComponent)!)!
    }
    
    private func setEnglishDescriptionDefault() {
        for pokemonDescription: PokemonDescription in descriptions! {
            if pokemonDescription.language == "en" {
                self.pokemonDescription = pokemonDescription
                self.formatDescriptionText()
                break
            }
        }
    }
    
    private func formatDescriptionText() {
        let text = self.pokemonDescription?.text?
            .stringByReplacingOccurrencesOfString("\n", withString: " ")
        self.pokemonDescription!.text = text
    }
}