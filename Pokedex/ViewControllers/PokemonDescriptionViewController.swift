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
    
    private var activityIndicatorView: DGActivityIndicatorView!
    
    private let pokedexStore = PokedexStore()
    
    private let synth = AVSpeechSynthesizer()
    private var speechUtterance: AVSpeechUtterance!
    
    private var descriptionText: String?
    private var speechText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.synth.delegate = self
        self.initalizeUIControls()
        self.initializeSpeechAnimation()
        self.initializeSpeechText()
    }
    
    override func viewWillDisappear(animated: Bool) {
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func startAudio(sender: UIButton) {
        self.activityIndicatorView.hidden = false
        self.activityIndicatorView.startAnimating()
        speechUtterance = AVSpeechUtterance(string: " \(self.speechText!)")
        synth.speakUtterance(speechUtterance)
    }
    
    private func initalizeUIControls() {
        self.descriptionTextView.text = ""
    }
    
    private func initializeSpeechAnimation() {
        self.activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.LineScalePulseOut)
        self.activityIndicatorView.tintColor = UIColor.flatRedColor()
        self.activityIndicatorView.frame = self.voiceAnimationView.bounds
        self.voiceAnimationView.addSubview(self.activityIndicatorView)
    }
    
    private func initializeSpeechText() {
        self.descriptionTextView.text = self.descriptionText!
    }
    
    func createDescriptionText(name name: String, types: [PokemonType], description: String) {
        self.speechText = "\(name)... "
        
        if types.count == 1 {
            self.speechText = self.speechText! + "\(types[0].name!) pokemon... "
        } else {
            self.speechText = self.speechText! + "\(types[0].name!) and \(types[1].name!) pokemon... "
        }
        
        self.speechText = self.speechText! + "\(description)"
        self.descriptionText = description
    }
}

extension PokemonDescriptionViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if self.activityIndicatorView.animating == true {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidden = true
        }
    }
}
