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
        setupInitialViewState()
        initializeStateViews()
        getPokemonDetails()
        // showMockData()
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
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokemonDetailViewController.getPokemonDetails),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView
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
        dispatch_async(dispatch_get_main_queue()) {
            currentViewController?.willMoveToParentViewController(nil)
            currentViewController!.view.removeFromSuperview()
            currentViewController?.removeFromParentViewController()
        }
    }
    
    private func addViewControllerToTabContentView(viewController: UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
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
    
    func showMockData() {
        let mock = Pokemon()
        mock.id = 1
        mock.name = "Bulbasaur"
        mock.url = "http://nikolamajcen.com"
        
        // Types
        let type1 = PokemonType()
        type1.name = "grass"
        type1.url = ""
        
        let type2 = PokemonType()
        type2.name = "poison"
        type2.url = ""
        
        mock.types = [type1, type2]
        
        // Description
        mock.descriptionInfo = PokemonDescription()
        mock.descriptionInfo?.language = "en"
        mock.descriptionInfo?.version = "v1"
        mock.descriptionInfo?.text = "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger."
        
        // Evolution
        let evolution1 = PokemonEvolution()
        evolution1.identifier = 1
        evolution1.name = "Charmander"
        evolution1.url = ""
        
        let evolution2 = PokemonEvolution()
        evolution2.identifier = 2
        evolution2.name = "Charmeleon"
        evolution2.url = ""
        
        let evolution3 = PokemonEvolution()
        evolution3.identifier = 3
        evolution3.name = "Charizard"
        evolution3.url = ""
        
        mock.evolutionChain = PokemonEvolutionChain()
        mock.evolutionChain?.identifier = 1
        mock.evolutionChain?.evolutions.append(evolution1)
        mock.evolutionChain?.evolutions.append(evolution2)
        mock.evolutionChain?.evolutions.append(evolution3)
        
        // Stats
        let stat1 = PokemonStat()
        stat1.name = "Attack"
        stat1.value = 50
        
        let stat2 = PokemonStat()
        stat2.name = "Defence"
        stat2.value = 50
        
        let stat3 = PokemonStat()
        stat3.name = "Special"
        stat3.value = 50
        
        let stat4 = PokemonStat()
        stat4.name = "Lalalla"
        stat4.value = 50
        
        let stat5 = PokemonStat()
        stat5.name = "Lalalala"
        stat5.value = 50
        
        let stat6 = PokemonStat()
        stat6.name = "Lalalala"
        stat6.value = 50
        
        mock.stats = [stat1, stat2, stat3, stat4, stat5, stat6]
        // endLoading()
        pokemon = mock
        isContentDownloaded = true
        showPokemonDetalView()
    }

}