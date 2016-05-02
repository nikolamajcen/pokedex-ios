//
//  EmptyView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class EmptyView: StateView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func setupView() {
        initializeNib(self, viewName: "EmptyView")
        initializeView(self, view: view)
        
        self.messageLabel.text = "No data."
        self.messageLabel.textColor = UIColor.flatRedColor()
    }
}
