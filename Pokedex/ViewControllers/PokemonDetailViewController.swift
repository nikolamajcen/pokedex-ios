//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import StatefulViewController

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabelFirst: UILabel!
    @IBOutlet weak var typeLabelSecond: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    
    let pokedexStore = PokedexStore()
    var identifier: Int?
    var pokemon: Pokemon?
    var pokemonDescription: PokemonDescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialViewState()
        self.initializeStateViews()
        self.initializeUI()
        
        self.getPokemonData()
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        self.changePokemonDetailsViewController(sender.selectedSegmentIndex)
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
        
        self.segmentControl.selectedSegmentIndex = 0
    }
    
    func initializeUIColors() {
        let color = self.typeLabelFirst.backgroundColor
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = color
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.tintColor = color
        
        self.segmentControl.tintColor = color
    }
    
    func changePokemonDetailsViewController(index: Int) {
        self.currentViewController?.view.removeFromSuperview()
        self.currentViewController?.removeFromParentViewController()
        
        switch index {
        case 0:
            let viewController = self.storyboard?
                .instantiateViewControllerWithIdentifier("PokemonDescriptionViewController")
                as! PokemonDescriptionViewController
            viewController.identifier = identifier
            viewController.pokemonName = self.pokemon?.name
            viewController.setTypeString((self.pokemon?.types)!)
            addSubviewToContentArea(viewController)
            break
        case 1:
            let viewController = (self.storyboard?
                .instantiateViewControllerWithIdentifier("EvolutionChainViewController"))!
            addSubviewToContentArea(viewController)
            break
        default:
            let viewController = UIViewController()
            addSubviewToContentArea(viewController)
        }
    }
    
    func addSubviewToContentArea(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.contentView.bounds
        viewController.didMoveToParentViewController(self)
        self.contentView.addSubview(viewController.view)
        
        self.currentViewController = viewController
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
    
    func showPokemonData(pokemon: Pokemon) {
        self.title = pokemon.name
        self.pokemonImage.image = UIImage(named: pokemon.getListImageName())
        
        self.idLabel.text =  "#\(pokemon.id!)"
        self.nameLabel.text = pokemon.name
        
        showHeightAndWeight(pokemon)
        showTypes(pokemon)
        
        initializeUIColors()
        changePokemonDetailsViewController(0)
    }
    
    func showHeightAndWeight(pokemon: Pokemon) {
        self.heightLabel.text = "\(pokemon.height!)m"
        self.weightLabel.text = "\(pokemon.weigth!)kg"
    }
    
    func showTypes(pokemon: Pokemon) {
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
    }
}

extension PokemonDetailViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.pokemon != nil
    }
}