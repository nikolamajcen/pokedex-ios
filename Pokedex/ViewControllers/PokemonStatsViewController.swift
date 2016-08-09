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
    
    var textColor: UIColor?
    var tintColor: UIColor?
    var backgroundColor: UIColor?
    
    var pokemon: Pokemon?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showStats()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        view.setNeedsDisplay()
    }
    
    func setColors(textColor textColor: UIColor, tintColor: UIColor, backgroundColor: UIColor) {
        self.textColor = textColor
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
    
    private func showStats() {
        for stat: PokemonStat in (pokemon?.stats)! {
            let statView = PokemonStatView()
            statView.showStat(name: stat.name, value: stat.value, labelColor: textColor!,
                              tintColor: tintColor!, backgroundColor: backgroundColor!)
            statsContainerView.addArrangedSubview(statView)
        }
    }
}
