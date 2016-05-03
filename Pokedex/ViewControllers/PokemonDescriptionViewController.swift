//
//  PokemonDescriptionViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 02/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonDescriptionViewController: UIViewController {

    var identifier: Int?
    let pokedexStore = PokedexStore()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.text = ""
        self.getDescriptionData()
    }
    
    func getDescriptionData() {
        pokedexStore.fetchPokemonAdditionInfo(identifier!) { (pokemonInfo, error) in
            if error == nil {
                self.descriptionTextView.text = pokemonInfo.pokemonDescription!.text
            }
        }
    }
}
