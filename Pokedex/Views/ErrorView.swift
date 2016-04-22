//
//  ErrorView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.redColor()
    }
}
