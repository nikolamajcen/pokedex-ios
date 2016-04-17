//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PokedexViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Removes blank space between navigation bar and table view
        self.automaticallyAdjustsScrollViewInsets = false

        self.viewModel = PokedexViewModel()
        self.tableView.delegate = self
        
        self.viewModel.pokemons!
            .asObservable()
            .bindTo(self.tableView.rx_itemsWithCellIdentifier("PokemonCell",
                cellType: PokedexItemCell.self)) { (row, element, cell) in
                    cell.pokemonImage.image = UIImage(named: (element.name?.lowercaseString)!)
                    cell.pokemonId!.text = "ID: \(element.id!)"
                    cell.pokemonName!.text = element.name!
                    cell.pokemonTypeFirst!.text = "grass".uppercaseString
                    cell.pokemonTypeFirst!.backgroundColor = TypeColor.getColorByType("grass")
            }
            .addDisposableTo(disposeBag)
    }
}

extension PokedexViewController: UITableViewDelegate {
    
}