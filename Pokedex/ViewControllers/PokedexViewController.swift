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

class PokedexViewController: UIViewController {

    let pokedexStore = PokedexStore()
    var pokedexData = [Pokemon]()

    var searchController: UISearchController!
    var searchData = [Pokemon]()
    
    @IBOutlet weak var pokedexTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        pokedexTable.delegate = self
        pokedexTable.dataSource = self
        
        initializeSearch()
        initializeStateViews()
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
        detailViewController.hidesBottomBarWhenPushed = true
        detailViewController.identifier = pokemon.id
        detailViewController.title = pokemon.name
    }
    
    func getPokedexData() {
        startLoading()
        pokedexStore.fetchPokemons { (pokemons, error) in
            if error == nil {
                self.pokedexData = pokemons
                self.pokedexTable.reloadData()
                self.endLoading()
            } else {
                self.endLoading(error: error)
            }
        }
    }
    
    private func initializeStateViews() {
        setupInitialViewState()
        
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokedexViewController.getPokedexData),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView
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
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor.flatRedColor()
        
        let tabBar = tabBarController?.tabBar
        tabBar?.tintColor = UIColor.flatRedColor()
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
            let alert = UIAlertController(title: "Search not allowed",
                                          message: "Pokedex data is not loaded yet. Wait or try again to download pokedex data.",
                                          preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
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