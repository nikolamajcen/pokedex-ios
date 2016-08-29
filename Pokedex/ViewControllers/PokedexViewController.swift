//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import StatefulViewController
import RealmSwift
import SCLAlertView

class PokedexViewController: UIViewController {
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    let pokedexStore = PokedexStore()
    var pokedexData = [Pokemon]()
    
    var searchController: UISearchController!
    var searchData = [Pokemon]()
    
    var tintColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        
        initializeStateViews()
        initializeSearch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initializeUIColors()
        getPokedexData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = pokedexTable.indexPathForSelectedRow
        let detailViewController = segue.destinationViewController as! PokemonDetailViewController
        
        let pokemon: Pokemon
        if searchController.active == true {
            pokemon = (searchData[(path?.row)!] as Pokemon)
        } else {
            pokemon = (pokedexData[(path?.row)!] as Pokemon)
        }
        detailViewController.identifier = pokemon.id
        detailViewController.title = pokemon.name
    }
    
    func getPokedexData() {
        pokedexStore.fetchPokemons { (pokemons) in
            self.pokedexData = pokemons
            self.pokedexTable.reloadData()
            self.endLoading()
        }
    }
    
    private func initializeStateViews() {
        setupInitialViewState()
        loadingView = LoadingView(owner: self)
        emptyView = EmptyView(owner: self)
        errorView = ErrorView(owner: self, action: #selector(getPokedexData))
    }
    
    private func initializeSearch() {
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.delegate = self
            controller.searchBar.sizeToFit()
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            return controller
        })()
        navigationItem.titleView = searchController.searchBar
    }
    
    private func initializeUIColors() {
        if tintColor == nil {
            tintColor = navigationController?.navigationBar.barTintColor
        } else {
            navigationController?.navigationBar.barTintColor = tintColor
        }
    }
}

extension PokedexViewController: StatefulViewController {
    func hasContent() -> Bool {
        return pokedexData.count > 0
    }
}

extension PokedexViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pokedexTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension PokedexViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        if searchController.active == true {
            if searchData.count == 0 {
                return PokedexCell()
            }
            pokemon = searchData[indexPath.row]
        } else {
            pokemon = pokedexData[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PokedexCell", forIndexPath: indexPath) as! PokedexCell
        cell.pokemon = pokemon
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active == true {
            return searchData.count
        } else {
            return pokedexData.count
        }
    }
}

extension PokedexViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if pokedexData.isEmpty == true {
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alert.addButton("OK", action: { })
            alert.showError("Search is not allowed", subTitle: "Pokedex is currently empty.")
            return false
        }
        return true
    }
}

extension PokedexViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercaseString
        searchData = pokedexData.filter { pokemon in
            return pokemon.name.lowercaseString.containsString(searchText!)
        }
        pokedexTable.reloadData()
    }
}