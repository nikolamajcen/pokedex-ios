//
//  PokemonEvolution.swift
//  Pokedex
//
//  Created by Nikola Majcen on 07/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonEvolutionChain: NSObject, Mappable {
    
    var identifier = 0
    var evolutions = [PokemonEvolution]()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        
        let json = map.JSON["chain"] as! [String: Any]
        let evolution = Mapper<PokemonEvolution>().map(JSON: json)
        
        if isPokemonFromFirstGeneration(identifier: (evolution?.identifier)!) == true {
            evolutions.append(evolution!)
        }
        
        var jsonArray = json["evolves_to"]! as! [AnyObject]
        if jsonArray.count == 0 {
            return
        }
        for _ in 1...2 {
            let jsonObject = jsonArray[0]
            
            if let evolution = Mapper<PokemonEvolution>().map(JSONObject: jsonObject) {
                // Only adds evolutions from first generation
                if isPokemonFromFirstGeneration(identifier: evolution.identifier) == true {
                    evolutions.append(evolution)
                }
            } else {
                break
            }
            
            jsonArray = jsonObject["evolves_to"]!! as! [AnyObject]
            if jsonArray.count == 0 {
                break
            }
        }
    }
    
    private func isPokemonFromFirstGeneration(identifier: Int) -> Bool {
        return identifier <= 151
    }
}
