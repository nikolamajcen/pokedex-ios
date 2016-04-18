//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import RxSwift

class PokemonDetailsViewModel: NSObject {
    
    var pokedexStore: PokedexStore!
    var pokemon: Observable<Pokemon>?
    
    init(id: Int) {
        super.init()
        self.pokedexStore = PokedexStore()
        pokemon = self.getPokemonDetails(id)
    }
    
    func getPokemonDetails(id: Int) -> Observable<Pokemon> {
        return Observable.create({ (observer) in
            _ = self.pokedexStore.fetchPokemonDetails(id, completion: { (result) in
                if result != nil {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            })
            return AnonymousDisposable { }
        })
    }
}