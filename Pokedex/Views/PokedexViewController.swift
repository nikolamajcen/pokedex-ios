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
    
    var downloadSuccess = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = PokedexViewModel()
        
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokedexViewController.getData),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView
        
        // Removes blank space between navigation bar and table view
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.delegate = self
        
        setupInitialViewState()
        
        self.getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func putDataInTable() {
        self.viewModel.pokemons!
            .asObservable()
            .bindTo(self.tableView.rx_itemsWithCellIdentifier("PokemonCell",
                cellType: PokedexItemCell.self)) { (row, element, cell) in
                    cell.pokemonImage.image = UIImage(named: (element.getListImageName()))
                    cell.pokemonId!.text = "#\(element.id!)"
                    cell.pokemonName!.text = element.name!
            }
            .addDisposableTo(disposeBag)
    }
    
    func getData() {
        startLoading()
        self.viewModel.getData()
        
        self.viewModel.pokemons!
            .asObservable()
            .subscribeCompleted {
                self.downloadSuccess = true
                self.endLoading()
                self.putDataInTable()
            }
            .addDisposableTo(disposeBag)
        
        self.viewModel.pokemons!
            .asObservable()
            .subscribeError { (error) in
                self.downloadSuccess = false
                self.endLoading(error: error)
            }
            .addDisposableTo(disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow
        let detailViewController = segue.destinationViewController as! PokemonDetailViewController
        detailViewController.identifier = (path?.row)! + 1
    }
}

extension PokedexViewController: StatefulViewController {
    func hasContent() -> Bool {
        return downloadSuccess
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