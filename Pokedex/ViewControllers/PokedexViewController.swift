//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import StatefulViewController

class PokedexViewController: UIViewController {

    let pokedexStore = PokedexStore()
    var pokemons = [Pokemon]()
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removes blank space between navigation bar and table view
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.pokedexTable.delegate = self
        self.pokedexTable.dataSource = self
        
        self.setupInitialViewState()
        self.initializeStateViews()
        
        self.getPokedexData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.initializeUIColors()
    }
    
    func initializeStateViews() {
        self.loadingView = LoadingView(frame: view.frame)
        self.emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokedexViewController.getPokedexData),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        self.errorView = customErrorView
    }
    
    func initializeUIColors() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.flatRedColor()
        
        let tabBar = self.tabBarController?.tabBar
        tabBar?.barTintColor = UIColor.flatRedColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.pokedexTable.indexPathForSelectedRow
        let detailViewController = segue.destinationViewController as! PokemonDetailViewController
        detailViewController.identifier = (path?.row)! + 1
        detailViewController.title = (self.pokemons[(path?.row)!] as Pokemon).name
    }
    
    func getPokedexData() {
        self.startLoading()
        self.pokedexStore.fetchPokemons { (pokemons, error) in
            if error == nil {
                self.pokemons = pokemons
                self.endLoading()
                self.pokedexTable.reloadData()
            } else {
                self.endLoading(error: error)
            }
        }
    }
}

extension PokedexViewController: StatefulViewController {
    func hasContent() -> Bool {
        return self.pokemons.count > 0
    }
}

extension PokedexViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.pokedexTable.editing == true {
            return UITableViewCellEditingStyle.Delete;
        }
        return UITableViewCellEditingStyle.None;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.pokedexTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension PokedexViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pokemon = self.pokemons[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PokedexCell", forIndexPath: indexPath) as! PokedexCell
        cell.idLabel.text = "#\(pokemon.id!)"
        cell.nameLabel.text = pokemon.name
        cell.pokemonImage.image = UIImage(named: pokemon.getListImageName())
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
}
