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
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonTypeLabelFirst: UILabel!
    @IBOutlet weak var pokemonTypeLabelSecond: UILabel!
    @IBOutlet weak var tabSegmentControl: UISegmentedControl!
    @IBOutlet weak var tabContentView: UIView!
    
    private var currentTabViewController: UIViewController?
    private var textColor: UIColor?
    private var tintColor: UIColor?
    private var backgroundColor: UIColor?
    
    private let pokedexStore = PokedexStore()
    private var pokemon: Pokemon?
    private var isContentDownloaded = false
    
    var identifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeStateViews()
        getPokemonDetails()
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if pokemon?.descriptionInfo == nil {
                getPokemonDescription()
            } else {
                openDescriptionTabContentView()
            }
        case 1:
            if pokemon?.evolutionChain?.evolutions.count == 0 {
                getPokemonEvolutionChain()
            } else {
                openEvolutionChainTabContentView()
            }
        case 2:
            openStatsTabContentView()
        default:
            break
        }
    }
    
    func getPokemonDetails() {
        startLoading()
        pokedexStore.fetchPokemonDetails(identifier!) { (pokemon, error) in
            if error == nil {
                self.pokemon = pokemon
                // Download chain
                self.getPokemonDescription()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    func getPokemonDescription() {
        pokedexStore.fetchPokemonSpecies(identifier!) { (result, error) in
            if error == nil {
                self.pokemon!.descriptionInfo = result.pokemonDescription
                self.pokemon?.evolutionChain!.identifier = result.pokemonEvolutionChainId
                // Download chain
                self.getPokemonEvolutionChain()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    func getPokemonEvolutionChain() {
        pokedexStore.fetchPokemonEvolutionChain((pokemon?.evolutionChain!.identifier)!) { (result, error) in
            if error == nil {
                self.pokemon?.evolutionChain? = result
                self.isContentDownloaded = true
                self.showPokemonDetalView()
                self.endLoading()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    private func initializeStateViews() {
        setupInitialViewState()
        loadingView = LoadingView(owner: self)
        emptyView = EmptyView(owner: self)
        errorView = ErrorView(owner: self, action: #selector(getPokemonDetails))
    }
    
    private func initializeUI() {
        textColor = pokemonIdLabel.textColor
        tintColor = pokemonTypeLabelFirst.backgroundColor
        backgroundColor = view.backgroundColor
        
        navigationController?.navigationBar.barTintColor = tintColor
        tabSegmentControl.tintColor = tintColor
    }
    
    private func showPokemonDetalView() {
        title = pokemon!.name
        pokemonImage.image = UIImage(named: pokemon!.getListImageName())
        pokemonIdLabel.text =  "#\(pokemon!.id)"
        pokemonNameLabel.text = pokemon!.name
        
        initializeTypeLabels(pokemon!)
        initializeUI()
        
        openDescriptionTabContentView()
    }
    
    private func initializeTypeLabels(pokemon: Pokemon) {
        if pokemon.types?.count == 1 {
            pokemonTypeLabelSecond.hidden = true
        }
        
        for type in pokemon.types! {
            if pokemon.types?.indexOf(type) == 0 {
                pokemonTypeLabelFirst.text = type.name.uppercaseString
                pokemonTypeLabelFirst.backgroundColor = type.getTypeColor()
            } else {
                pokemonTypeLabelSecond.text = type.name.uppercaseString
                pokemonTypeLabelSecond.backgroundColor = type.getTypeColor()
            }
        }
    }
    
    private func openDescriptionTabContentView() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonDescriptionViewController")
            as! PokemonDescriptionViewController
        viewController.pokemon = pokemon
        viewController.setColors(tintColor: tintColor!)
        changeTabContentSubview(viewController)
    }
    
    private func openEvolutionChainTabContentView() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonEvolutionChainViewController")
            as! PokemonEvolutionViewController
        viewController.pokemon = pokemon
        viewController.setColors(textColor: textColor!)
        changeTabContentSubview(viewController)
    }
    
    private func openStatsTabContentView() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonStatsViewController")
            as! PokemonStatsViewController
        viewController.pokemon = pokemon
        viewController.setColors(textColor: textColor!, tintColor: tintColor!, backgroundColor: backgroundColor!)
        changeTabContentSubview(viewController)
    }
    
    private func changeTabContentSubview(viewController: UIViewController) {
        removeViewControllerFromTabContentView()
        addViewControllerToTabContentView(viewController)
    }
    
    private func removeViewControllerFromTabContentView() {
        let currentViewController = childViewControllers.last
        performUpdatesOnMain { 
            currentViewController?.willMoveToParentViewController(nil)
            currentViewController!.view.removeFromSuperview()
            currentViewController?.removeFromParentViewController()
        }
    }
    
    private func addViewControllerToTabContentView(viewController: UIViewController) {
        performUpdatesOnMain { 
            self.addChildViewController(viewController)
            viewController.view.frame = self.tabContentView.bounds
            viewController.didMoveToParentViewController(self)
            self.tabContentView.addSubview(viewController.view)
        }
        currentTabViewController = viewController
    }
}

extension PokemonDetailViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.isContentDownloaded
    }
}