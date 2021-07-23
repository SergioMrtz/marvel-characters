//
//  LocalDataManager.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 22/7/21.
//

import UIKit

class LocalDataManager {

    var storedEntities: [CharacterEntity] = []

    func updateEntities(entities: CharactersListEntity) {
        guard let characters = entities.characters else {
            return
        }
        if self.storedEntities.count == 0 {
            self.storedEntities = characters
        } else {
            let newCharacters = entities.characters?.filter { c in (self.storedEntities.contains(where: { $0.id != c.id}))}
            self.storedEntities.append(contentsOf: newCharacters ?? [])
        }
    }

    func getCharacter(id: Int) -> CharacterEntity? {
        let character = self.storedEntities.filter({$0.id == id}).first
        return character
    }

}
