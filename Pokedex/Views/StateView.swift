//
//  StateView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class StateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() { }
    
    func initializeNib(container: UIView, viewName: String) {
        NSBundle.mainBundle().loadNibNamed(viewName, owner: container, options: nil)
    }
    
    func initializeView(container: UIView, view: UIView) {
        view.frame = container.bounds
        container.addSubview(view)
    }
}
