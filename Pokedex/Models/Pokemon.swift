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
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.url <- (map["url"], URLTransform())
        self.name <- map["name"]
        
        self.id = Int((url?.absoluteURL.lastPathComponent)!)!
        
        makeFirstLetterInNameUppercase()
        if isGenderSpecifiedInName() == true {
            addGenderSign()
        }
    }
    
    private func makeFirstLetterInNameUppercase() -> Void {
        let startIndex = self.name!.startIndex
        let endIndex = self.name!.startIndex
        let firstLetterUppercase = String(self.name!.characters.first! as Character).uppercaseString
        
        self.name = self.name!
            .stringByReplacingCharactersInRange(startIndex...endIndex,
                                                withString: firstLetterUppercase)
    }
    
    private func isGenderSpecifiedInName() -> Bool {
        return self.id == 29 || self.id == 32
    }
    
    private func addGenderSign() -> Void {
        let startIndex = self.name!.endIndex.advancedBy(-2)
        let endIndex = self.name!.endIndex.predecessor()
        
        switch self.id! {
        case 29:
            self.name?.replaceRange(startIndex...endIndex, with: "♀")
        case 32:
            self.name?.replaceRange(startIndex...endIndex, with: "♂")
        default:
            break
        }
    }
}