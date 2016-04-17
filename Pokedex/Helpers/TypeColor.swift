//
//  TypeColor.swift
//  Pokedex
//
//  Created by Nikola Majcen on 17/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class TypeColor {
    
    static func getColorByType(type: String) -> UIColor {
        var colors = [Int]()
        
        switch type {
        case PokemonTypes.Bug.rawValue:
            colors = [168, 184, 32]
            break
        case PokemonTypes.Dark.rawValue:
            colors = [112, 88, 72]
            break
        case PokemonTypes.Dragon.rawValue:
            colors = [112, 56, 248]
            break
        case PokemonTypes.Eletric.rawValue:
            colors = [248, 208, 48]
            break
        case PokemonTypes.Fairy.rawValue:
            colors = [238, 153, 172]
            break
        case PokemonTypes.Fighting.rawValue:
            colors = [192, 48, 40]
            break
        case PokemonTypes.Fire.rawValue:
            colors = [240, 128, 48]
            break
        case PokemonTypes.Flying.rawValue:
            colors = [168, 144, 240]
            break
        case PokemonTypes.Ghost.rawValue:
            colors = [112, 88, 152]
            break
        case PokemonTypes.Grass.rawValue:
            colors = [120, 200, 80]
            break
        case PokemonTypes.Ground.rawValue:
            colors = [224, 192, 104]
            break
        case PokemonTypes.Ice.rawValue:
            colors = [152, 216, 216]
            break
        case PokemonTypes.Normal.rawValue:
            colors = [168, 168, 120]
            break
        case PokemonTypes.Poison.rawValue:
            colors = [160, 64, 160]
            break
        case PokemonTypes.Psychic.rawValue:
            colors = [248, 88, 136]
            break
        case PokemonTypes.Rock.rawValue:
            colors = [184, 160, 56]
            break
        case PokemonTypes.Steel.rawValue:
            colors = [184, 184, 208]
            break
        case PokemonTypes.Water.rawValue:
            colors = [104, 144, 240]
            break
        default:
            colors = [255, 255, 255]
        }
        
        let red   = CGFloat(colors[0]) / 255
        let green = CGFloat(colors[1]) / 255
        let blue  = CGFloat(colors[2]) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}