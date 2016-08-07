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
import GaugeKit

class PokemonDescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var circleView: Gauge!
    @IBOutlet weak var voiceAnimationView: UIView!
    
    private var activityIndicatorView: DGActivityIndicatorView!
    private var tintColor: UIColor?
    
    private let synth = AVSpeechSynthesizer()
    private var speechUtterance: AVSpeechUtterance!

    private var descriptionText: String?
    private var speechText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        initializeUI()
        initializeSpeechAnimation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        synth.stopSpeakingAtBoundary(.Immediate)
    }

    func addColorStylesToView(color: UIColor) {
        tintColor = color
    }
    
    func createDescriptionText(name name: String, types: [PokemonType], description: String) {
        speechText = "\(name)... "
        if types.count == 1 {
            speechText = speechText! + "\(types[0].name) pokemon... "
        } else {
            speechText = speechText! + "\(types[0].name) and \(types[1].name) pokemon... "
        }
        speechText = speechText! + "\(description)"
        descriptionText = description
    }
    
    func startSpeech() {
        if synth.speaking == true {
            stopSpeech()
            return
        }
        speechUtterance = AVSpeechUtterance(string: " \(speechText!)")
        synth.speakUtterance(speechUtterance)
    }
    
    func stopSpeech() {
        synth.stopSpeakingAtBoundary(.Immediate)
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    private func initializeUI() {
        descriptionLabel.text = descriptionText
        circleView.startColor = tintColor!
    }
    
    private func initializeSpeechAnimation() {
        activityIndicatorView = DGActivityIndicatorView(type: .TriplePulse)
        activityIndicatorView.tintColor = tintColor
        activityIndicatorView.frame = self.voiceAnimationView.bounds
        activityIndicatorView
            .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startSpeech)))
        voiceAnimationView.addSubview(self.activityIndicatorView)
    }
}

extension PokemonDescriptionViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        if self.activityIndicatorView.animating == false {
            dispatch_async(dispatch_get_main_queue(), { 
                self.activityIndicatorView.startAnimating()
            })
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        if self.activityIndicatorView.animating == true {
            dispatch_async(dispatch_get_main_queue(), { 
                self.activityIndicatorView.stopAnimating()
            })
        }
    }
}
