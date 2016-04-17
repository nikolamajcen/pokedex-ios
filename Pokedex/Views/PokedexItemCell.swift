//
//  PokedexItemCell.swift
//  Pokedex
//
//  Created by Nikola Majcen on 17/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokedexItemCell: UITableViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonId: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonTypeFirst: UILabel!
    @IBOutlet weak var pokemonTypeSecond: UILabel!
    
    override func layoutSubviews() {
        self.pokemonTypeFirst.clipsToBounds = true
        self.pokemonTypeFirst.layer.cornerRadius = 5
        self.pokemonTypeSecond.clipsToBounds = true
        self.pokemonTypeSecond.layer.cornerRadius = 5
    }
}
