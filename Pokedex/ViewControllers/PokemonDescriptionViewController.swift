//
//  PokemonDescriptionViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 02/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import AVFoundation
import DGActivityIndicatorView

class PokemonDescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var voiceAnimationView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    
    private var activityIndicatorView: DGActivityIndicatorView!
    
    private let pokedexStore = PokedexStore()
    
    private let synth = AVSpeechSynthesizer()
    private var speechUtterance: AVSpeechUtterance!
    
    private var descriptionText: String?
    private var speechText: String?
    
    private var primaryColor: UIColor?
    private var accentColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.synth.delegate = self
        self.initializeUIColors()
        self.initializeUIControls()
        self.initializeSpeechAnimation()
        self.initializeSpeechText()
    }
    
    override func viewWillDisappear(animated: Bool) {
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func startAudio(sender: UIButton) {
        speechUtterance = AVSpeechUtterance(string: " \(self.speechText!)")
        synth.speakUtterance(speechUtterance)
    }
    
    func createDescriptionText(name name: String, types: [PokemonType], description: String) {
        self.speechText = "\(name)... "
        
        if types.count == 1 {
            self.speechText = self.speechText! + "\(types[0].name) pokemon... "
        } else {
            self.speechText = self.speechText! + "\(types[0].name) and \(types[1].name) pokemon... "
        }
        
        self.speechText = self.speechText! + "\(description)"
        self.descriptionText = description
    }
    
    func addColorStylesToView(primaryColor primaryColor: UIColor, accentColor: UIColor) {
        self.primaryColor = primaryColor
        self.accentColor = accentColor
    }
    
    private func initializeUIColors() {
        // COLOR
    }
    
    private func initializeUIControls() {
        self.descriptionTextView.text = ""
        self.audioButton.backgroundColor = self.primaryColor
        self.audioButton.tintColor = self.accentColor
        self.audioButton.layer.cornerRadius = 5
    }
    
    private func initializeSpeechAnimation() {
        self.activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.LineScalePulseOut)
        self.activityIndicatorView.tintColor = self.primaryColor
        self.activityIndicatorView.frame = self.voiceAnimationView.bounds
        self.voiceAnimationView.addSubview(self.activityIndicatorView)
    }
    
    private func initializeSpeechText() {
        self.descriptionTextView.text = self.descriptionText!
    }
}

extension PokemonDescriptionViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        if self.activityIndicatorView.animating == false {
            self.activityIndicatorView.startAnimating()
            self.activityIndicatorView.hidden = false
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if self.activityIndicatorView.animating == true {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
        }
    }
}
