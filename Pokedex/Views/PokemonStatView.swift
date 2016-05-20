//
//  PokemonStatView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 14/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PokemonStatView: StateView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var statBarBackLayer: UIView!
    @IBOutlet weak var statBarFrontLayer: UIView!
    @IBOutlet weak var statBarFrontLayerWidth: NSLayoutConstraint!
    
    var barTintColor = UIColor.flatGrayColorDark()
    var barBackgroundColor = UIColor.flatWhiteColorDark()
    
    var statMaxValue = 180.0
    var barBorderWidth = 5
    var barRadius = 5
    
    override func setupView() {
        initializeNib(self, viewName: "PokemonStatView")
        initializeView(self, view: view)
    }
    
    func showStat(name name: String, value: Int) {
        self.statLabel.text = name
        self.initializeBarBackLayer()
        self.initializeBarFrontLayer(value)
    }
    
    private func initializeBarBackLayer() {
        self.statBarBackLayer.layer.cornerRadius = CGFloat(self.barRadius)
        self.statBarBackLayer.backgroundColor = self.barBackgroundColor
    }
    
    private func initializeBarFrontLayer(value: Int) {
        self.statBarFrontLayer.layer.cornerRadius = CGFloat(self.barRadius)
        self.statBarFrontLayer.backgroundColor = self.barTintColor
        
        var barWidthMultiplier = CGFloat(Double(value) / self.statMaxValue)
        if barWidthMultiplier > 1 {
            barWidthMultiplier = 1
        }
        
        self.statBarFrontLayerWidth = NSLayoutConstraint(item: self.statBarFrontLayer,
                                                         attribute: .Width,
                                                         relatedBy: .Equal,
                                                         toItem: self.statBarBackLayer,
                                                         attribute: .Width,
                                                         multiplier: barWidthMultiplier,
                                                         constant: 0)
        self.view.addConstraint(self.statBarFrontLayerWidth)
    }
}
