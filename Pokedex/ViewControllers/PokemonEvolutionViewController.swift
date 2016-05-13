//
//  PokemonEvolutionViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 13/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonEvolutionViewController: UIViewController {
    
    @IBOutlet weak var evolutionFirstImage: UIImageView!
    @IBOutlet weak var evolutionSecondImage: UIImageView!
    @IBOutlet weak var evolutionThirdImage: UIImageView!
    
    @IBOutlet weak var evolutionFirstIdentifierLabel: UILabel!
    @IBOutlet weak var evolutionSecondIdentifierLabel: UILabel!
    @IBOutlet weak var evolutionThirdIdentifierLabel: UILabel!
    
    @IBOutlet weak var evolutionFirstNameLabel: UILabel!
    @IBOutlet weak var evolutionSecondNameLabel: UILabel!
    @IBOutlet weak var evolutionThirdNameLabel: UILabel!
    
    var evolutions: [PokemonEvolution]?
    var imageNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeUI()
        self.showEvolutions()
    }
    
    private func initializeUI() {
        self.evolutionFirstNameLabel.text = ""
        self.evolutionSecondNameLabel.text = ""
        self.evolutionThirdNameLabel.text = ""
        
        self.evolutionFirstIdentifierLabel.text = ""
        self.evolutionSecondIdentifierLabel.text = ""
        self.evolutionThirdIdentifierLabel.text = ""
    }
    
    private func showEvolutions() {
        for evolution: PokemonEvolution in self.evolutions! {
            showEvolution(evolution, evolutionNumber: (self.evolutions?.indexOf(evolution))!)
        }
    }
    
    private func showEvolution(evolution: PokemonEvolution, evolutionNumber: Int) {
        switch evolutionNumber {
        case 0:
            evolutionFirstIdentifierLabel.text = "#\(evolution.identifier!)"
            evolutionFirstNameLabel.text = evolution.name
            evolutionFirstImage.image = UIImage(named: ImageHelper.getListImageName(evolution.identifier!))
            break
        case 1:
            evolutionSecondIdentifierLabel.text = "#\(evolution.identifier!)"
            evolutionSecondNameLabel.text = evolution.name
            evolutionSecondImage.image = UIImage(named: ImageHelper.getListImageName(evolution.identifier!))
            break
        case 2:
            evolutionThirdIdentifierLabel.text = "#\(evolution.identifier!)"
            evolutionThirdNameLabel.text = evolution.name
            evolutionThirdImage.image = UIImage(named: ImageHelper.getListImageName(evolution.identifier!))
            break
        default:
            break
        }
    }
}