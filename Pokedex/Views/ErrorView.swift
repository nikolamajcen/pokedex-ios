//
//  ErrorView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class ErrorView: StateView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(owner: UIViewController, action: Selector) {
        super.init(frame: CGRect.zero)
        initializeNib(owner: self, name: "ErrorView")
        initializeView(container: self, view: contentView)
        reloadButton.addTarget(owner, action: action, for: .touchUpInside)
    }
}
