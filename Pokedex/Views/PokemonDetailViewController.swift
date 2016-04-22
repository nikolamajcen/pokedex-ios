//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StatefulViewController

class PokemonDetailViewController: UIViewController, StatefulViewController {
    
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabelFirst: UILabel!
    @IBOutlet weak var typeLabelSecond: UILabel!
    
    var viewModel: PokemonDetailsViewModel!
    let disposeBag = DisposeBag()
    
    var identifier: Int?
    var downloadSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PokemonDetailsViewModel()
        
        setupInitialViewState()
        initializeStateViews()
        initializeUI()
        
        self.getData()
    }
    
    private func initializeStateViews() {
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        
        let customErrorView = ErrorView(frame: view.frame)
        customErrorView.reloadButton
            .addTarget(self, action: #selector(PokedexViewController.getData),
                       forControlEvents: UIControlEvents.TouchUpInside)
        
        errorView = customErrorView
    }
    
    private func initializeUI() {
        self.idLabel.text = ""
        self.nameLabel.text = ""
        self.typeLabelFirst.text = ""
        self.typeLabelSecond.text = ""
    }
    
    func getData() {
        startLoading()
        self.viewModel.getData(identifier!)
        
        self.viewModel.pokemon!
            .asObservable()
            .subscribeNext { (pokemon) in
                self.downloadSuccess = true
                self.endLoading()
                
                self.title = pokemon.name
                self.pokemonImage.image = UIImage(named: pokemon.getListImageName())
                
                self.idLabel.text =  "#\(pokemon.id!)"
                self.nameLabel.text = pokemon.name
                
                if pokemon.types?.count == 1 {
                    self.typeLabelSecond.hidden = true
                }
                
                for index in  0...((pokemon.types?.count)! - 1) {
                    guard let typeName = (pokemon.types![index]).name else {
                        break
                    }
                    
                    if index == 0 {
                        self.typeLabelFirst.text = typeName.uppercaseString
                        self.typeLabelFirst.backgroundColor = TypeColor.getColorByType(typeName)
                        self.typeLabelFirst.layer.cornerRadius = 5
                        self.typeLabelFirst.clipsToBounds = true
                    } else if index == 1 {
                        self.typeLabelSecond.text = typeName.uppercaseString
                        self.typeLabelSecond.backgroundColor = TypeColor.getColorByType(typeName)
                        self.typeLabelSecond.layer.cornerRadius = 5
                        self.typeLabelSecond.clipsToBounds = true
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func hasContent() -> Bool {
        return downloadSuccess
    }
}
