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
    
    func fetchPokemons(completion: ([Pokemon]!) -> Void) {
        Alamofire.request(.GET, "https://pokeapi.co/api/v2/pokemon/?limit=151&offset=0")
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value!["results"] else {
                    completion(nil)
                    return
                }
                
                let pokemons = Mapper<Pokemon>().mapArray(value)
                completion(pokemons)
        }
    }
}