//
//  PokemonDescriptionViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 02/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    let synth = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
    
    var identifier: Int?
    var pokemonName: String?
    private var pokemonType: String?
    let pokedexStore = PokedexStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.text = ""
        self.getDescriptionData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func startAudio(sender: UIButton) {
        speechUtterance = AVSpeechUtterance(string: "\(pokemonName!)...")
        synth.speakUtterance(speechUtterance)
        
        speechUtterance = AVSpeechUtterance(string: "\(pokemonType!)...")
        synth.speakUtterance(speechUtterance)

        speechUtterance = AVSpeechUtterance(string: "\(descriptionTextView.text!)")
        synth.speakUtterance(speechUtterance)
    }
    
    func getDescriptionData() {
        pokedexStore.fetchPokemonAdditionInfo(identifier!) { (pokemonInfo, error) in
            if error == nil {
                self.descriptionTextView.text = pokemonInfo.pokemonDescription!.text
            }
        }
    }
    
    func setTypeString(types: [PokemonType]) {
        if types.count > 1 {
            self.pokemonType = "\(types[0].name!) and \(types[1].name!) pokemon"
        } else {
            self.pokemonType = "\(types[0].name!) pokemon"
        }
    }
}
