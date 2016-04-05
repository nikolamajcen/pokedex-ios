//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import Alamofire

class PokedexViewModel: NSObject {
    
    var pokedexStore: PokedexStore!
    // Need to remove (RxSwift)
    var pokedexView: PokedexViewController!
    var pokemons: [Pokemon]?
    
    // Need to remove parameter
    init(view: PokedexViewController) {
        super.init()
        self.pokedexStore = PokedexStore()
        self.pokedexView = view
        self.pokemons = [Pokemon]()
        self.getPokemons()
    }
    
    func getPokemons() {
        pokedexStore.fetchPokemons { (result) in
            if result == nil {
                self.pokemons = [Pokemon]()
            } else {
                self.pokemons = result
                // Need to remove
                self.pokedexView.tableView.reloadData()
            }
        }
    }
}