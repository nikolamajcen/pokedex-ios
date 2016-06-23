//
//  SecondViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class TrainerViewController: UIViewController {

    @IBOutlet weak var trainerImage: UIImageView!
    @IBOutlet weak var trainerName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeControls()
    }
    
    private func initializeUI() {
        self.trainerImage.clipsToBounds = true
        self.trainerImage.layer.cornerRadius = self.trainerImage.frame.width / 2
        self.trainerImage.layer.borderWidth = 2.5
        self.trainerImage.layer.borderColor = UIColor.flatGrayColor().CGColor
    }
    
    private func initializeControls() {
        let imageTap = UITapGestureRecognizer(target: self,
                                                      action: #selector(TrainerViewController.changeTrainerPhoto))
        let nameTap = UITapGestureRecognizer(target: self,
                                             action: #selector(TrainerViewController.changeTrainerName))
        
        self.trainerImage.userInteractionEnabled = true
        self.trainerImage.addGestureRecognizer(imageTap)
        
        self.trainerName.userInteractionEnabled = true
        self.trainerName.addGestureRecognizer(nameTap)
        
    }
    
    internal func changeTrainerPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .Camera
            imagePickerController.allowsEditing = false
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = false
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Cannot open camera or photo library.",
                                                    preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    internal func changeTrainerName() {
        let changeNameController = UIAlertController(title: "Trainer name",
                                                     message: "Enter new name: ",
                                                     preferredStyle: .Alert)
        
        changeNameController.addTextFieldWithConfigurationHandler { (textField) in
            if (self.trainerName.text?.characters.count == 0) {
                textField.placeholder = "Enter your name"
            } else {
                textField.text = self.trainerName.text
            }
        }
        
        let changeNameCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let changeNameSaveAction = UIAlertAction(title: "Save", style: .Default) {
            [unowned self, changeNameController] (action: UIAlertAction!) in
                let name = changeNameController.textFields![0].text
                if (name?.characters.count > 0) {
                    self.trainerName.text = name
            }
        }
        
        changeNameController.addAction(changeNameCancelAction)
        changeNameController.addAction(changeNameSaveAction)
        self.presentViewController(changeNameController, animated: true, completion: nil)
    }
}

extension TrainerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.trainerImage.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

