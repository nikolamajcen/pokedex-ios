//
//  PokemonEvolutionViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 13/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonEvolutionViewController: UIViewController {
    
    @IBOutlet weak var evolutionFirstView: UIStackView!
    @IBOutlet weak var evolutionSecondView: UIStackView!
    @IBOutlet weak var evolutionThirdView: UIStackView!
    
    @IBOutlet weak var evolutionFirstImage: UIImageView!
    @IBOutlet weak var evolutionSecondImage: UIImageView!
    @IBOutlet weak var evolutionThirdImage: UIImageView!
    
    @IBOutlet weak var evolutionFirstIdentifierLabel: UILabel!
    @IBOutlet weak var evolutionSecondIdentifierLabel: UILabel!
    @IBOutlet weak var evolutionThirdIdentifierLabel: UILabel!
    
    @IBOutlet weak var evolutionFirstNameLabel: UILabel!
    @IBOutlet weak var evolutionSecondNameLabel: UILabel!
    @IBOutlet weak var evolutionThirdNameLabel: UILabel!
    
    private var textColor: UIColor?
    
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        showEvolutions()
    }
    
    func setColors(textColor: UIColor) {
        self.textColor = textColor
    }
    
    private func initializeUI() {
        evolutionFirstNameLabel.textColor = textColor
        evolutionSecondNameLabel.textColor = textColor
        evolutionThirdNameLabel.textColor = textColor
        
        evolutionFirstIdentifierLabel.textColor = textColor
        evolutionSecondIdentifierLabel.textColor = textColor
        evolutionThirdIdentifierLabel.textColor = textColor
    }
    
    private func showEvolutions() {
        let evolutions = pokemon?.evolutionChain?.evolutions
        switch (evolutions!.count) {
        case 1:
            evolutionSecondView.isHidden = true
            evolutionThirdView.isHidden = true
        case 2:
            evolutionThirdView.isHidden = true
        default:
            break
        }
        
        for evolution: PokemonEvolution in evolutions! {
            showEvolution(evolution: evolution, evolutionNumber: (evolutions?.index(of: evolution))!)
        }
    }
    
    private func showEvolution(evolution: PokemonEvolution, evolutionNumber: Int) {
        switch evolutionNumber {
        case 0:
            evolutionFirstIdentifierLabel.text = "#\(evolution.identifier)"
            evolutionFirstNameLabel.text = evolution.name
            evolutionFirstImage.image = UIImage(named: ImageHelper.getListImageName(id: evolution.identifier))
        case 1:
            evolutionSecondIdentifierLabel.text = "#\(evolution.identifier)"
            evolutionSecondNameLabel.text = evolution.name
            evolutionSecondImage.image = UIImage(named: ImageHelper.getListImageName(id: evolution.identifier))
        case 2:
            evolutionThirdIdentifierLabel.text = "#\(evolution.identifier)"
            evolutionThirdNameLabel.text = evolution.name
            evolutionThirdImage.image = UIImage(named: ImageHelper.getListImageName(id: evolution.identifier))
        default:
            break
        }
    }
}
