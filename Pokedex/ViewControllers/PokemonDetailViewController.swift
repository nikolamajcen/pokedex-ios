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
    private var isContentDownloaded = false
    
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
                self.openDescriptionTabContentView()
            }
            break
        case 1:
            if pokemon?.evolutionChain?.evolutions.count == 0 {
                self.getPokemonEvolutionChain()
            } else {
                self.openEvolutionChainTabContentView()
            }
            break
        case 2:
            self.openStatsTabContentView()
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
                self.showPokemonDetalView()
                self.isContentDownloaded = true
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
        
        // COLOR
    }
    
    private func showPokemonDetalView() {
        self.title = self.pokemon!.name
        self.pokemonImage.image = UIImage(named: self.pokemon!.getListImageName())
        
        self.pokemonIdLabel.text =  "#\(self.pokemon!.id!)"
        self.pokemonNameLabel.text = self.pokemon!.name
        self.showTypes(self.pokemon!)
        
        self.initializeUIColors()
        self.openDescriptionTabContentView()
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
        let currentViewController = self.childViewControllers.last
        currentViewController?.willMoveToParentViewController(nil)
        currentViewController!.view.removeFromSuperview()
        currentViewController?.removeFromParentViewController()
        
        self.addChildViewController(viewController)
        viewController.view.frame = self.tabContentView.bounds
        viewController.didMoveToParentViewController(self)
        self.tabContentView.addSubview(viewController.view)
        self.currentViewController = viewController
    }
    
    private func openDescriptionTabContentView() {
        let viewController = self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonDescriptionViewController")
            as! PokemonDescriptionViewController
        viewController.createDescriptionText(name: (pokemon?.name)!,
                                             types: (pokemon?.types)!,
                                             description: (pokemon?.descriptionInfo?.text)!)
        viewController.addColorStylesToView(primaryColor: TypeColor.getColorByType(self.pokemon!.types![0].name!),
                                            accentColor: UIColor.flatWhiteColor())
        self.addSubviewToTabContentView(viewController)
    }
    
    private func openEvolutionChainTabContentView() {
        let viewController = self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonEvolutionChainViewController")
        as! PokemonEvolutionViewController
        viewController.evolutions = self.pokemon?.evolutionChain?.evolutions
        self.addSubviewToTabContentView(viewController)
    }
    
    private func openStatsTabContentView() {
        let viewController = self.storyboard?
            .instantiateViewControllerWithIdentifier("PokemonStatsViewController")
        as! PokemonStatsViewController
        viewController.stats = self.pokemon?.stats
        self.addSubviewToTabContentView(viewController)
    }
}

extension PokemonDetailViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.isContentDownloaded
    }
}