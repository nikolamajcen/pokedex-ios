//
//  TrainerViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import GaugeKit
import SCLAlertView

class TrainerViewController: UIViewController {
    
    @IBOutlet weak var trainerImage: UIImageView!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var captureNumberLabel: UILabel!
    @IBOutlet weak var capturePercentageLabel: UILabel!
    @IBOutlet weak var gauge: Gauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initializeUI()
    }

    private func initializeUI() {        
        if UserDefaultsManager.trainerImage != nil {
            trainerImage.image = UserDefaultsManager.trainerImage
        }
        
        if UserDefaultsManager.trainerName != nil {
            trainerNameLabel.text = UserDefaultsManager.trainerName
        }
        
        let numberOfCapturedPokemons = DatabaseManager().getAllPokemons().count
        if numberOfCapturedPokemons == 0 {
            gauge.rate = 0.0
            captureNumberLabel.text = "0/151"
            capturePercentageLabel.text = "0.00%"
        } else {
            let capturePercentage = (CGFloat(numberOfCapturedPokemons) / 151.0) * 100.0
            gauge.rate = capturePercentage
            captureNumberLabel.text = "\(numberOfCapturedPokemons)/151"
            capturePercentageLabel.text = String(format: "%.2f", capturePercentage) + "%"
        }
    }
    
    private func initializeControls() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(changeTrainerPhoto))
        trainerImage.userInteractionEnabled = true
        trainerImage.addGestureRecognizer(imageTap)
    }
    
    internal func changeTrainerPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            dispatch_async(dispatch_get_main_queue(), {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .PhotoLibrary
                imagePickerController.allowsEditing = false
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            })
        } else if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            dispatch_async(dispatch_get_main_queue(), {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .Camera
                imagePickerController.allowsEditing = false
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            })
        } else {
            let alert = SCLAlertView()
            dispatch_async(dispatch_get_main_queue(), { 
                alert.showError("Error", subTitle: "Cannot open camera or photo library.")
            })
        }
    }
}

extension TrainerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        UserDefaultsManager.trainerImage = image
        dispatch_async(dispatch_get_main_queue()) { 
            self.trainerImage.image = image
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

