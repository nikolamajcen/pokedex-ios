//
//  PokemonStat.swift
//  Pokedex
//
//  Created by Nikola Majcen on 09/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonStat: NSObject, Mappable {
    
    var name = ""
    var value = 0
    
    override init() {
        super.init()
    }
    
    required  init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["stat.name"]
        name = name.uppercased()
        
        value <- map["base_stat"]
        formatSpecialStatsForm()
    }
    
    private func formatSpecialStatsForm() {
        if name.contains("-") == true {
            name = name.replacingOccurrences(of: "SPECIAL-", with: "SP.")
        }
    }
}
