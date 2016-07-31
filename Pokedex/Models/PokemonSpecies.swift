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
        descriptions <- map["flavor_text_entries"]
        setEnglishDescriptionDefault()
        
        pokemonEvolutionChainUrl <- (map["evolution_chain.url"], URLTransform())
        pokemonEvolutionChainId = Int((pokemonEvolutionChainUrl?.absoluteURL.lastPathComponent)!)!
    }
    
    private func setEnglishDescriptionDefault() {
        for description: PokemonDescription in descriptions! {
            if description.language == "en" {
                pokemonDescription = formatDescriptionText(description)
                break
            }
        }
    }
    
    private func formatDescriptionText(description: PokemonDescription) -> PokemonDescription {
        description.text = description.text?.stringByReplacingOccurrencesOfString("\n", withString: " ")
        return description
    }
}