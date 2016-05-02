//
//  ErrorView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class ErrorView: StateView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var errorImage: UIImageView!
    
    override func setupView() {
        initializeNib(self, viewName: "ErrorView")
        initializeView(self, view: view)
        
        self.errorImage.image = UIImage(named: "Pokeball Empty")
    }
}
