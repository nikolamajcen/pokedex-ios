//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class Pokemon: NSObject, Mappable {
    
    var url: NSURL?
    var id: Int?
    var name: String?
    var types: [PokemonType]?
    var weigth: Float?
    var height: Float?
    var descriptionInfo: PokemonDescription?
    var evolutionChainId: Int?
    var evolutionChain: [PokemonEvolution]?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.url <- (map["url"], URLTransform())
        self.name <- map["name"]
        
        if self.url != nil {
            self.id = Int((url?.absoluteURL.lastPathComponent)!)!
        } else {
            self.id <- map["id"]
        }
        
        makeFirstLetterInNameUppercase()
        if isGenderSpecifiedInName() == true {
            addGenderSign()
        }
        
        self.types <- map["types"]
        self.types = self.types?.reverse()
        
        self.weigth <- map["weight"]
        self.height <- map["height"]
        
        if self.weigth != nil {
            self.weigth = self.weigth! / 10
        }
        
        if self.height != nil {
            self.height = self.height! / 10
        }
    }
    
    func getListImageName() -> String {
        var number = ""
        
        if self.id < 10 {
            number = "00\(self.id!)"
        } else if id < 100 {
            number = "0\(self.id!)"
        } else {
            number = "\(self.id!)"
        }
        
        return "P\(number)S"
    }
    
    private func makeFirstLetterInNameUppercase() -> Void {
        let startIndex = self.name!.startIndex
        let endIndex = self.name!.startIndex
        let firstLetterUppercase = String(self.name!.characters.first! as Character).uppercaseString
        self.name!.replaceRange(startIndex...endIndex, with: firstLetterUppercase)
    }
    
    private func isGenderSpecifiedInName() -> Bool {
        return self.id == 29 || self.id == 32
    }
    
    private func addGenderSign() -> Void {
        let startIndex = self.name!.endIndex.advancedBy(-2)
        let endIndex = self.name!.endIndex.predecessor()
        var sign = ""
        
        switch self.id! {
        case 29:
            sign = "♀"
            break
        case 32:
            sign = "♂"
            break
        default:
            break
        }
        
        self.name?.replaceRange(startIndex...endIndex, with: sign)
    }
}