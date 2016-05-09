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
    
    private var currentViewController: UIViewController?
    
    var identifier: Int?
    
    private let pokedexStore = PokedexStore()
    private var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialViewState()
        self.initializeStateViews()
        self.initializeUIControls()
        
        self.getPokemonDetails()
    }
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if pokemon?.descriptionInfo == nil {
                self.getPokemonDescription()
            } else {
                self.showDescriptionTabContentView()
            }
            break
        case 1:
            if pokemon?.evolutionChain?.evolutions.count == 0 {
                self.getPokemonEvolutionChain()
            } else {
                self.showEvolutionChainTabContentView()
            }
            break
        case 2:
            // TODO: See if stats are already fetched
            self.showStatsTabContentView()
            break
        default:
            break
        }
    }
    
    func getPokemonDetails() {
        self.startLoading()
        self.pokedexStore.fetchPokemonDetails(identifier!) { (pokemon, error) in
            if error == nil {
                self.pokemon = pokemon
                self.showPokemonDetails(pokemon)
                
                // TODO: Remove printing and add showing on screen
                for stat: PokemonStat in pokemon.stats! {
                    print("\(stat.name!) - \(stat.value!)")
                }
                
                self.endLoading()
                self.getPokemonDescription()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    func getPokemonDescription() {
        // TODO: Show loading in subview when downloading description
        pokedexStore.fetchPokemonSpecies(identifier!) { (result, error) in
            if error == nil {
                self.pokemon!.descriptionInfo = result.pokemonDescription
                self.pokemon?.evolutionChain!.identifier = result.pokemonEvolutionChainId
                self.showDescriptionTabContentView()
            } else {
                // TODO: Show error on fail
                print("Download error")
            }
        }
    }
    
    func getPokemonEvolutionChain() {
        // TODO: Show loading in subview when downloading description
        pokedexStore.fetchPokemonEvolutionChain((pokemon?.evolutionChain!.identifier)!) { (result, error) in
            if error == nil {
                self.pokemon?.evolutionChain? = result
                
                // TODO: Remove printing and add showing on screen
                for evolution: PokemonEvolution in (self.pokemon?.evolutionChain!.evolutions)! {
                    print("#\(evolution.identifier!) \(evolution.name!)")
                }
                
                self.showEvolutionChainTabContentView()
            } else {
                // TODO: Show error on fail
                print("Download error")
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
    
    private func initializeUIControls() {
        self.pokemonIdLabel.text = ""
        self.pokemonNameLabel.text = ""
        self.pokemonTypeLabelFirst.text = ""
        self.pokemonTypeLabelSecond.text = ""
        
        self.tabSegmentControl.selectedSegmentIndex = 0
    }
    
    private func initializeUIColors() {
        let color = self.pokemonTypeLabelFirst.backgroundColor
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = color
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.tintColor = color
        
        self.tabSegmentControl.tintColor = color
    }
    
    private func showPokemonDetails(pokemon: Pokemon) {
        self.title = pokemon.name
        self.pokemonImage.image = UIImage(named: pokemon.getListImageName())
        
        self.pokemonIdLabel.text =  "#\(pokemon.id!)"
        self.pokemonNameLabel.text = pokemon.name
        self.showTypes(pokemon)
        
        self.initializeUIColors()
    }
    
    private func showTypes(pokemon: Pokemon) {
        if pokemon.types?.count == 1 {
            self.pokemonTypeLabelSecond.hidden = true
        }
        
        for index in  0...((pokemon.types?.count)! - 1) {
            guard let typeName = (pokemon.types![index]).name else {
                break
            }
            
            if index == 0 {
                let navigationBar = self.navigationController?.navigationBar
                navigationBar?.barTintColor = TypeColor.getColorByType(typeName)
                self.pokemonTypeLabelFirst.text = typeName.uppercaseString
                self.pokemonTypeLabelFirst.backgroundColor = TypeColor.getColorByType(typeName)
                self.pokemonTypeLabelFirst.layer.cornerRadius = 5
                self.pokemonTypeLabelFirst.clipsToBounds = true
            } else if index == 1 {
                self.pokemonTypeLabelSecond.text = typeName.uppercaseString
                self.pokemonTypeLabelSecond.backgroundColor = TypeColor.getColorByType(typeName)
                self.pokemonTypeLabelSecond.layer.cornerRadius = 5
                self.pokemonTypeLabelSecond.clipsToBounds = true
            }
        }
    }
    
    private func addSubviewToTabContentView(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.tabContentView.bounds
        viewController.didMoveToParentViewController(self)
        self.tabContentView.addSubview(viewController.view)
        self.currentViewController = viewController
    }
    
    private func showDescriptionTabContentView() {
        let viewController = self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonDescriptionViewController")
            as! PokemonDescriptionViewController
        viewController.createDescriptionText(name: (pokemon?.name)!,
                                             types: (pokemon?.types)!,
                                             description: (pokemon?.descriptionInfo?.text)!)
        self.addSubviewToTabContentView(viewController)
    }
    
    private func showEvolutionChainTabContentView() {
        let viewController = (self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonEvolutionChainViewController"))!
        self.addSubviewToTabContentView(viewController)
    }
    
    private func showStatsTabContentView() {
        let viewController = (self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonStatsViewController"))!
        self.addSubviewToTabContentView(viewController)
    }
    
    private func showErrorTabContentView() {
        let viewController = UIViewController()
        self.addSubviewToTabContentView(viewController)
    }
}

extension PokemonDetailViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.pokemon != nil
    }
}