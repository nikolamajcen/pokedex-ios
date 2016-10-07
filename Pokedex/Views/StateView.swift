//
//  StateView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class StateView: UIView {
    
    func initializeNib(owner: UIView, name: String) {
        Bundle.main.loadNibNamed(name, owner: owner, options: nil)
    }
    
    func initializeView(container: UIView, view: UIView) {
        view.frame = container.bounds
        container.addSubview(view)
    }
}
