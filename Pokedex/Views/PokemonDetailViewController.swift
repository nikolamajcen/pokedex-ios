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
    @IBOutlet weak var typeLabelFirst: UILabel!
    @IBOutlet weak var typeLabelSecond: UILabel!
    
    
    var viewModel: PokemonDetailsViewModel!
    let disposeBag = DisposeBag()
    
    var identifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PokemonDetailsViewModel(id: identifier!)
        
        pokemonImage.image = UIImage(named: getListImageName(identifier!))
        
        self.idLabel.text = ""
        self.nameLabel.text = ""
        self.typeLabelFirst.text = ""
        self.typeLabelSecond.text = ""
        
        self.viewModel.pokemon!
            .asObservable()
            .subscribeNext { (pokemon) in
                self.title = pokemon.name
                
                self.idLabel.text =  "#\(pokemon.id!)"
                self.nameLabel.text = pokemon.name
                
                for index in  0...((pokemon.types?.count)! - 1) {
                    guard let typeName = (pokemon.types![index]).name else {
                        break
                    }
                    print(index)
                    
                    if index == 0 {
                        self.typeLabelFirst.text = typeName.uppercaseString
                        self.typeLabelFirst.backgroundColor = TypeColor.getColorByType(typeName)
                    } else if index == 1 {
                        self.typeLabelSecond.text = typeName.uppercaseString
                        self.typeLabelSecond.backgroundColor = TypeColor.getColorByType(typeName)
                    }
                }
            }
            .addDisposableTo(disposeBag)
        
        self.typeLabelFirst.layer.cornerRadius = 5
        self.typeLabelFirst.clipsToBounds = true
        self.typeLabelSecond.layer.cornerRadius = 5
        self.typeLabelSecond.clipsToBounds = true
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
