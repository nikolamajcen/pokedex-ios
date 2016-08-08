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
    private var textColor: UIColor?
    private var tintColor: UIColor?
    private var backgroundColor: UIColor?
    
    private let pokedexStore = PokedexStore()
    private var pokemon: Pokemon?
    private var isContentDownloaded = false
    
    var identifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialViewState()
        self.initializeStateViews()
        self.initializeUIControls()
        
        showMockData()
        // self.getPokemonDetails()
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
        evolution1.name = "Bulbasaur"
        evolution1.url = ""
        
        let evolution2 = PokemonEvolution()
        evolution2.identifier = 2
        evolution2.name = "Ivysaur"
        evolution2.url = ""
        
        let evolution3 = PokemonEvolution()
        evolution3.identifier = 3
        evolution3.name = "Venesaur"
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
        // loadingView = LoadingView(frame: view.frame)
        // emptyView = EmptyView(frame: view.frame)
        
        // let customErrorView = ErrorView(frame: view.frame)
        /*customErrorView.reloadButton
            .addTarget(self, action: #selector(PokemonDetailViewController.getPokemonDetails),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView*/
    }
    
    private func initializeUIControls() {
        pokemonIdLabel.text = ""
        pokemonNameLabel.text = ""
        pokemonTypeLabelFirst.text = ""
        pokemonTypeLabelSecond.text = ""
        tabSegmentControl.selectedSegmentIndex = 0
    }
    
    private func initializeUIColors() {
        textColor = pokemonIdLabel.textColor
        tintColor = pokemonTypeLabelFirst.backgroundColor
        backgroundColor = view.backgroundColor
        
        tabSegmentControl.tintColor = tintColor
        navigationController?.navigationBar.barTintColor = tintColor
    }
    
    private func showPokemonDetalView() {
        title = pokemon!.name
        pokemonImage.image = UIImage(named: pokemon!.getListImageName())
        
        pokemonIdLabel.text =  "#\(pokemon!.id)"
        pokemonNameLabel.text = pokemon!.name
        showTypes(pokemon!)
        
        initializeUIColors()
        openDescriptionTabContentView()
    }
    
    private func showTypes(pokemon: Pokemon) {
        if pokemon.types?.count == 1 {
            self.pokemonTypeLabelSecond.hidden = true
        }
        
        for index in  0...((pokemon.types?.count)! - 1) {
            
            let typeName = pokemon.types![index].name
            
            if typeName.isEmpty {
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
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonDescriptionViewController")
            as! PokemonDescriptionViewController
        viewController.pokemon = pokemon
        viewController.setColors(tintColor: tintColor!)
        self.addSubviewToTabContentView(viewController)
    }
    
    private func openEvolutionChainTabContentView() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonEvolutionChainViewController")
            as! PokemonEvolutionViewController
        viewController.pokemon = pokemon
        viewController.setColors(textColor: textColor!)
        self.addSubviewToTabContentView(viewController)
    }
    
    private func openStatsTabContentView() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PokemonStatsViewController")
            as! PokemonStatsViewController
        viewController.pokemon = pokemon
        viewController.setColors(textColor: textColor!, tintColor: tintColor!, backgroundColor: backgroundColor!)
        self.addSubviewToTabContentView(viewController)
    }
}

extension PokemonDetailViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.isContentDownloaded
    }
}