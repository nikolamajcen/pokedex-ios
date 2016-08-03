//
//  PokedexCell.swift
//  Pokedex
//
//  Created by Nikola Majcen on 17/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokedexCell: UITableViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon! {
        didSet {
            idLabel.text = "#\(pokemon.id!)"
            nameLabel.text = pokemon.name
            pokemonImage.image = UIImage(named: pokemon.getListImageName())
        }
    }
}
