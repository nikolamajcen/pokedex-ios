//
//  DatabaseManager.swift
//  Pokedex
//
//  Created by Nikola Majcen on 05/08/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import RealmSwift

enum DatabaseResult {
    case Success
    case Failure
}

class DatabaseManager: Object {
    
    func addPokemon(pokemon: Pokemon) -> DatabaseResult {
        if pokemonAlreadyExists(pokemon) == true { return .Failure }
        let realm = try! Realm()
        try! realm.write({
            realm.add(pokemon)
        })
        return .Success
    }
    
    func deletePokemon(pokemon: Pokemon) -> DatabaseResult {
        if pokemonAlreadyExists(pokemon) == true { return .Failure }
        let realm = try! Realm()
        try! realm.write({
            realm.delete(pokemon)
        })
        return .Success
    }
    
    func getAllPokemons() -> [Pokemon] {
        let realm = try! Realm()
        return Array(realm.objects(Pokemon.self).sorted("id"))
    }
    
    func deleteAllPokemons() {
        let realm = try! Realm()
        try! realm.write({ 
            realm.deleteAll()
        })
    }
    
    private func pokemonAlreadyExists(pokemon: Pokemon) -> Bool {
        let realm = try! Realm()
        if realm.objectForPrimaryKey(Pokemon.self, key: pokemon.id) != nil {
            return true
        }
        return false
    }
}
