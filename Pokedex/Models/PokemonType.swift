//
//  Type.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonType: NSObject, Mappable {
    
    var name = ""
    var url = ""
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        name <- map["type.name"]        
        url <- map["type.url"]
    }
    
    func formatName(name: String) -> String{
        return name.uppercaseString
    }
    
    func getTypeColor() -> UIColor {
        return ColorHelper.getColorByType(name)
    }
}