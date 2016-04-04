//
//  FirstViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = PokemonTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PokemonTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pokemon = self.viewModel.pokemons[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PokemonCell")! as UITableViewCell
        
        cell.textLabel?.text = pokemon.name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
}

