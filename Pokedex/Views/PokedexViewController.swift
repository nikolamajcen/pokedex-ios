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
import StatefulViewController

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PokedexViewModel!
    let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = PokedexViewModel()
        
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        errorView = ErrorView(frame: view.frame)
        
        // Removes blank space between navigation bar and table view
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        setupInitialViewState()
        startLoading()
        
        self.viewModel.pokemons!
            .asObservable()
            .subscribeCompleted {
                self.endLoading()
                self.putDataInTable()
            }
            .addDisposableTo(disposeBag)
        
        self.viewModel.pokemons!
            .asObservable()
            .subscribeError { (error) in
                self.endLoading(error: nil)
            }
            .addDisposableTo(disposeBag)
    }
    
    func putDataInTable() {
        self.viewModel.pokemons!
            .asObservable()
            .bindTo(self.tableView.rx_itemsWithCellIdentifier("PokemonCell",
                cellType: PokedexItemCell.self)) { (row, element, cell) in
                    cell.pokemonImage.image = UIImage(named: (self.getListImageName(element.id!)))
                    cell.pokemonId!.text = "#\(element.id!)"
                    cell.pokemonName!.text = element.name!
            }
            .addDisposableTo(disposeBag)
    }
    
    func getListImageName(id: Int) -> String {
        var number = ""
        
        if id < 10 {
            number = "00\(id)"
        } else if id < 100 {
            number = "0\(id)"
        } else {
            number = "\(id)"
        }
        
        return "P\(number)S"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow
        let detailViewController = segue.destinationViewController as! PokemonDetailViewController
        detailViewController.identifier = (path?.row)! + 1
    }
}

extension PokedexViewController: StatefulViewController {
    
    func hasContent() -> Bool {
        return false
    }
    
    func handleErrorWhenContentAvailable(error: ErrorType) {
        // Something...
    }
}

extension PokedexViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing == true {
            return UITableViewCellEditingStyle.Delete;
        }
        return UITableViewCellEditingStyle.None;
    }
}