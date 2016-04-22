//
//  LoadingView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class LoadingView: StateView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func setupView() {
        initializeNib(self, viewName: "LoadingView")
        initializeView(self, view: view)
        
        loadingLabel.text = "Loading..."
        loadingIndicator.startAnimating()
    }
}
