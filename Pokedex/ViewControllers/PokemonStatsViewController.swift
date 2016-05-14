//
//  PokemonStatsViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 14/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonStatsViewController: UIViewController {

    
    @IBOutlet weak var statsContainerView: UIStackView!
    
    var stats: [PokemonStat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showStats()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.setNeedsDisplay()
    }
    
    private func showStats() {
        for pokemonStat: PokemonStat in stats!{
            let stat = PokemonStatView(frame: statsContainerView.bounds)
            stat.showStat(name: pokemonStat.name!, value: pokemonStat.value!)
            statsContainerView.addArrangedSubview(stat)
        }
    }
}
