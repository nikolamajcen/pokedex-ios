//
//  PokemonTableViewModel.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class PokemonTableViewModel: NSObject {
    
    var pokemons: [Pokemon]
    
    override init() {
        self.pokemons = [Pokemon]()
        
        let pokemonList = ["Bulbasaur", "Ivysaur", "Venosaur",
                           "Charmander", "Charmeleon", "Charizard",
                           "Squirtle", "Wartorle", "Blastoise"]
        
        var counter = 0
        for name in pokemonList {
            counter += 1
            let pokemon = Pokemon()
            pokemon.id = counter
            pokemon.name = name
            pokemons.append(pokemon)
        }
    }
}