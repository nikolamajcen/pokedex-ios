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
    
    var statMaxValue = 180.0
    var barCornerRadius = 5.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRectZero)
        initializeNib(self, name: "PokemonStatView")
        initializeView(self, view: view)
    }
    
    func showStat(name name: String, value: Int, labelColor: UIColor, tintColor: UIColor, backgroundColor: UIColor) {
        view.backgroundColor = backgroundColor
        initializeLabel(text: name, textColor: labelColor)
        initializeBarFrontLayer(statValue: value, color: tintColor)
        initializeBarBackLayer(color: tintColor)
    }
    
    private func initializeLabel(text text: String, textColor: UIColor) {
        statLabel.text = text
        statLabel.textColor = textColor
    }
    
    private func initializeBarBackLayer(color color: UIColor) {
        statBarBackLayer.layer.cornerRadius = CGFloat(barCornerRadius)
        statBarBackLayer.backgroundColor = UIColor.flatWhiteColorDark()
        // statBarBackLayer.backgroundColor = color.colorWithAlphaComponent(0.33)
    }
    
    private func initializeBarFrontLayer(statValue statValue: Int, color: UIColor) {
        statBarFrontLayer.layer.cornerRadius = CGFloat(barCornerRadius)
        statBarFrontLayer.backgroundColor = color
        
        var barWidthMultiplier = CGFloat(Double(statValue) / statMaxValue)
        if barWidthMultiplier > 1 {
            barWidthMultiplier = 1
        }
        
        statBarFrontLayerWidth = NSLayoutConstraint(item: statBarFrontLayer, attribute: .Width, relatedBy: .Equal,
                                                    toItem: statBarBackLayer, attribute: .Width,
                                                    multiplier: barWidthMultiplier, constant: 0)
        view.addConstraint(statBarFrontLayerWidth)
    }
}
