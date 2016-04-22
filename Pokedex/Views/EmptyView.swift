//
//  EmptyView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        NSBundle.mainBundle()
            .loadNibNamed("EmptyView", owner: self, options: nil)
        
        self.messageLabel.text = "No internet connection."
        
        self.view.backgroundColor = UIColor.redColor()
        self.view.frame = self.bounds
        self.addSubview(self.view)
    }
}
