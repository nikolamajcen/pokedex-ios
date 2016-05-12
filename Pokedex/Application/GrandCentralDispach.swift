//
//  GrandCentralDispach.swift
//  Pokedex
//
//  Created by Nikola Majcen on 12/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

func performUpdatesOnMain(update: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        update()
    }
}