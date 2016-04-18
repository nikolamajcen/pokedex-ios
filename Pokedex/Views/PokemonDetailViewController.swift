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

class PokemonDetailViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    var viewModel: PokemonDetailsViewModel!
    let disposeBag = DisposeBag()
    
    var identifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PokemonDetailsViewModel()
        
        label.text = String(identifier!)
    }
}
