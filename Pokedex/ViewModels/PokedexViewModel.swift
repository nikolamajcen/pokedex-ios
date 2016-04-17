//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift

class PokedexViewModel: NSObject {
    
    var pokedexStore: PokedexStore!
    var pokemons: Observable<[Pokemon]>?

    override init() {
        super.init()
        self.pokedexStore = PokedexStore()
        pokemons = self.getPokemons()
    }
    
    func getPokemons() -> Observable<[Pokemon]> {
        return Observable.create({ (observer) in
            _ = self.pokedexStore.fetchPokemons({ (result) in
                if result != nil {
                    observer.onNext(result!)
                    observer.onCompleted()
                }
            })
            
            return AnonymousDisposable { }
        })
    }
}