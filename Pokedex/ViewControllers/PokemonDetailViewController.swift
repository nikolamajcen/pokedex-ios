//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import StatefulViewController

class PokemonDetailViewController: UIViewController, StatefulViewController {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabelFirst: UILabel!
    @IBOutlet weak var typeLabelSecond: UILabel!
    
    let pokedexStore = PokedexStore()
    var identifier: Int?
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialViewState()
        self.initializeStateViews()
        self.initializeUI()
        
        self.getPokemonData()
    }
    
    private func initializeStateViews() {
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokemonDetailViewController.getPokemonData),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView
    }
    
    func initializeUI() {
        self.idLabel.text = ""
        self.nameLabel.text = ""
        self.typeLabelFirst.text = ""
        self.typeLabelSecond.text = ""
    }
    
    func initializeUIColors() {
        let color = self.typeLabelFirst.backgroundColor
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = color
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.tintColor = color
    }
    
    func showPokemonData(pokemon: Pokemon) {
        self.title = pokemon.name
        self.pokemonImage.image = UIImage(named: pokemon.getListImageName())
        
        self.idLabel.text =  "#\(pokemon.id!)"
        self.nameLabel.text = pokemon.name
        
        if pokemon.types?.count == 1 {
            self.typeLabelSecond.hidden = true
        }
        
        for index in  0...((pokemon.types?.count)! - 1) {
            guard let typeName = (pokemon.types![index]).name else {
                break
            }
            
            if index == 0 {
                self.typeLabelFirst.text = typeName.uppercaseString
                let navigationBar = self.navigationController?.navigationBar
                navigationBar?.barTintColor = TypeColor.getColorByType(typeName)
                self.typeLabelFirst.backgroundColor = TypeColor.getColorByType(typeName)
                self.typeLabelFirst.layer.cornerRadius = 5
                self.typeLabelFirst.clipsToBounds = true
            } else if index == 1 {
                self.typeLabelSecond.text = typeName.uppercaseString
                self.typeLabelSecond.backgroundColor = TypeColor.getColorByType(typeName)
                self.typeLabelSecond.layer.cornerRadius = 5
                self.typeLabelSecond.clipsToBounds = true
            }
        }
        
        initializeUIColors()
    }
    
    func getPokemonData() {
        self.startLoading()
        self.pokedexStore.fetchPokemonDetails(identifier!) { (pokemon, error) in
            if error == nil {
                self.pokemon = pokemon
                self.showPokemonData(pokemon)
                self.endLoading()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    func hasContent() -> Bool {
        return self.pokemon != nil
    }
}
