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
    var pokedexData = [Pokemon]()

    var searchController: UISearchController!
    var searchData = [Pokemon]()
    
    @IBOutlet weak var pokedexTable: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removes blank space between navigation bar and table view
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Removes black screen when search is on and tab is changed
        self.definesPresentationContext = true
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.tintColor = UIColor.flatWhiteColor()
            return controller
        })()
        
        self.searchController.searchBar.delegate = self
        
        self.pokedexTable.delegate = self
        self.pokedexTable.dataSource = self
        
        self.setupInitialViewState()
        self.initializeStateViews()
        
        
        self.searchButton.target = self
        self.searchButton.action = #selector(PokedexViewController.showSearch)
        
        self.getPokedexData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.initializeUIColors()
        self.searchController.searchBar.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.pokedexTable.indexPathForSelectedRow
        let detailViewController = segue.destinationViewController as! PokemonDetailViewController
        
        let pokemon: Pokemon
        if self.searchController.active == true {
            pokemon = (self.searchData[(path?.row)!] as Pokemon)
        } else {
            pokemon = (self.pokedexData[(path?.row)!] as Pokemon)
            
        }
        
        detailViewController.identifier = pokemon.id
        detailViewController.title = pokemon.name
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
        tabBar?.tintColor = UIColor.flatRedColor()
    }
    
    func showSearch() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = self.searchController.searchBar
        self.searchController.active = true
    }
    
    func getPokedexData() {
        self.startLoading()
        self.pokedexStore.fetchPokemons { (pokemons, error) in
            if error == nil {
                self.pokedexData = pokemons
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
        return self.pokedexData.count > 0
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
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.searchBar.hidden = true
        return indexPath
    }
}

extension PokedexViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        if self.searchController.active == true {
            if self.searchData.count == 0 {
                return PokedexCell()
            }
            pokemon = self.searchData[indexPath.row]
        } else {
            pokemon = self.pokedexData[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PokedexCell", forIndexPath: indexPath) as! PokedexCell
        cell.idLabel.text = "#\(pokemon.id!)"
        cell.nameLabel.text = pokemon.name
        cell.pokemonImage.image = UIImage(named: pokemon.getListImageName())
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active == true {
            return self.searchData.count
        } else {
            return self.pokedexData.count
        }
    }
}

extension PokedexViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Pokedex"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search,
                                                                 target: self,
                                                                 action: #selector(PokedexViewController.showSearch))
    }
}

extension PokedexViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", self.searchController.searchBar.text!)
        let array = (self.pokedexData as NSArray) .filteredArrayUsingPredicate(searchPredicate)
        
        self.searchData = array as! [Pokemon]
        self.pokedexTable.reloadData()
    }
}