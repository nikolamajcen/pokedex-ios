//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonDetailViewController: UIViewController {
    
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: PokemonDetailsViewModel!
    let disposeBag = DisposeBag()
    
    var identifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PokemonDetailsViewModel(id: identifier!)
        
        pokemonImage.image = UIImage(named: getListImageName(identifier!))
        
        self.idLabel.text = ""
        self.nameLabel.text = ""
        
        self.viewModel.pokemon!
            .asObservable()
            .subscribeNext { (pokemon) in
                self.idLabel.text = String(pokemon.id!)
                self.nameLabel.text = pokemon.name
            }
            .addDisposableTo(disposeBag)
    }
    
    func getListImageName(id: Int) -> String {
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
