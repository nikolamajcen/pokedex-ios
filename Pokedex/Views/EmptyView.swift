//
//  EmptyView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class EmptyView: StateView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(owner: UIViewController) {
        super.init(frame: CGRect.zero)
        initializeNib(owner: self, name: "EmptyView")
        initializeView(container: self, view: contentView)
    }
}
