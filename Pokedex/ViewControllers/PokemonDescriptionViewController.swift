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
    
    @IBOutlet weak var voiceAnimationView: UIView!
    @IBOutlet weak var circleView: Gauge!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var speechUtterance: AVSpeechUtterance!
    
    private var activityIndicatorView: DGActivityIndicatorView!
    private var speechText: String?
    
    private var tintColor: UIColor?
    
    var pokemon: Pokemon? {
        didSet {
            formatTextForSpeech(name: (pokemon?.name)!, types: (pokemon?.types)!,
                                description: (pokemon?.descriptionInfo?.text)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
        initializeUI()
        initializeSpeechAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func setColors(tintColor: UIColor) {
        self.tintColor = tintColor
    }
    
    func manageSpeech() {
        if speechSynthesizer.isSpeaking == false {
            startSpeech()
        } else {
            stopSpeech()
        }
    }
    
    private func initializeUI() {
        circleView.startColor = tintColor!
        descriptionLabel.text = pokemon?.descriptionInfo?.text
    }
    
    private func initializeSpeechAnimation() {
        activityIndicatorView = DGActivityIndicatorView(type: .triplePulse, tintColor: tintColor)
        activityIndicatorView.frame = self.voiceAnimationView.bounds
        activityIndicatorView
            .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageSpeech)))
        voiceAnimationView.addSubview(self.activityIndicatorView)
    }
    
    private func formatTextForSpeech(name: String, types: [PokemonType], description: String) {
        speechText = "\(name)... "
        if types.count == 1 {
            speechText = speechText! + "\(types[0].name) pokemon... "
        } else {
            speechText = speechText! + "\(types[0].name) and \(types[1].name) pokemon... "
        }
        speechText = speechText! + "\(description)"
    }
    
    private func startSpeech() {
        speechUtterance = AVSpeechUtterance(string: " \(speechText!)")
        speechSynthesizer.speak(speechUtterance)
    }
    
    private func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    fileprivate func startVoiceAnimation() {
        if activityIndicatorView.animating == false {
            activityIndicatorView.startAnimating()
        }
    }
    
    fileprivate func stopVoiceAnimation() {
        if activityIndicatorView.animating == true {
            activityIndicatorView.stopAnimating()
        }
    }
}

extension PokemonDescriptionViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        startVoiceAnimation()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        stopVoiceAnimation()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        stopVoiceAnimation()
    }
}
