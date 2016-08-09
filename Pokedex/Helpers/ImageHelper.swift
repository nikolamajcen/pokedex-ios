//
//  ImageHelper.swift
//  Pokedex
//
//  Created by Nikola Majcen on 13/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class ImageHelper {
    
    static func getListImageName(id: Int) -> String {
        var number = ""
        
        if id < 10 {
            number = "00\(id)"
        } else if id < 100 {
            number = "0\(id)"
        } else {
            number = "\(id)"
        }
        return "P\(number)S"
    }
}