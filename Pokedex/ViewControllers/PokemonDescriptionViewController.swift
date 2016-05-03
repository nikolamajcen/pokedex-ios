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
    
    var activityIndicatorView: DGActivityIndicatorView!
    
    let synth = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    
    let pokedexStore = PokedexStore()
    var identifier: Int?
    var pokemonName: String?
    var pokemonType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.synth.delegate = self
        
        self.descriptionTextView.text = ""
        
        initializeSpeechAnimation()
        self.getDescriptionData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func startAudio(sender: UIButton) {
        self.activityIndicatorView.hidden = false
        self.activityIndicatorView.startAnimating()
        speechUtterance = AVSpeechUtterance(string: "\(pokemonName!)... \(pokemonType!)... \(descriptionTextView.text!)")
        synth.speakUtterance(speechUtterance)
    }
    
    func getDescriptionData() {
        pokedexStore.fetchPokemonAdditionInfo(identifier!) { (pokemonInfo, error) in
            if error == nil {
                self.descriptionTextView.text = pokemonInfo.pokemonDescription!.text
            }
        }
    }
    
    func initializeSpeechAnimation() {
        self.activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.LineScalePulseOut)
        self.activityIndicatorView.tintColor = UIColor.flatRedColor()
        // self.activityIndicatorView.backgroundColor = UIColor.flatNavyBlueColor()
        self.activityIndicatorView.frame = self.voiceAnimationView.bounds
        self.voiceAnimationView.addSubview(self.activityIndicatorView)
    }
    
    func setTypeString(types: [PokemonType]) {
        if types.count > 1 {
            self.pokemonType = "\(types[0].name!) and \(types[1].name!) pokemon"
        } else {
            self.pokemonType = "\(types[0].name!) pokemon"
        }
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
