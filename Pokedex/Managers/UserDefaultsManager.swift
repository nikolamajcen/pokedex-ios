//
//  UserDefaultsManager.swift
//  Pokedex
//
//  Created by Nikola Majcen on 24/06/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsManager {
    
    static var trainerName: String! {
        get {
            let defaults = initializeUserDefaults()
            let trainerName = defaults.string(forKey: "trainerName")
            return trainerName
        }
        set {
            let defaults = initializeUserDefaults()
            defaults.setValue(newValue, forKey: "trainerName")
        }
    }
    
    static var trainerImage: UIImage! {
        get {
            let defaults = initializeUserDefaults()
            let trainerImageData = defaults.data(forKey: "trainerImage")
            
            guard trainerImageData != nil else {
                return nil
            }
            
            let trainerImage = UIImage(data: trainerImageData!)
            return trainerImage
        }
        set {
            let defaults = initializeUserDefaults()
            defaults.setValue(UIImageJPEGRepresentation(newValue, 100), forKey: "trainerImage")
        }
    }
    
    static var gameMode: Bool! {
        get {
            let defaults = initializeUserDefaults()
            let gameStatus = defaults.bool(forKey: "gameMode")
            return gameStatus
        }
        set {
            let defaults = initializeUserDefaults()
            defaults.set(newValue, forKey: "gameMode")
        }
    }
    
    private static func initializeUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
}
