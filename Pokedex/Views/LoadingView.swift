//
//  LoadingView.swift
//  Pokedex
//
//  Created by Nikola Majcen on 22/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class LoadingView: StateView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var activityIndicator = DGActivityIndicatorView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(owner: UIViewController) {
        super.init(frame: CGRectZero)
        initializeNib(self, name: "LoadingView")
        initializeView(self, view: contentView)
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        if activityIndicator.animating == false {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
    
    private func startAnimating() {
        activityIndicator = DGActivityIndicatorView(type: .BallClipRotateMultiple, tintColor: UIColor.flatRedColorDark())
        activityIndicator.frame = activityIndicatorView.bounds
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
