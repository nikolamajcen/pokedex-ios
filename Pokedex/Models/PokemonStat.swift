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
    
    var name: String?
    var value: Int?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.name <- map["stat.name"]
        self.value <- map["base_stat"]
        
        self.capitalizeName()
        self.changeSpecialStatsForm()
    }
    
    private func capitalizeName() {
        self.name = self.name?.uppercaseString
    }
    
    private func changeSpecialStatsForm() {
        if self.name?.containsString("-") == true {
            self.name = self.name?
                .stringByReplacingOccurrencesOfString("SPECIAL-", withString: "SP.")
        }
    }
}