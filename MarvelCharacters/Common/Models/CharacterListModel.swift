//
//  CharacterListModel.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

class CharacterListModel {
    let id: Int?
    let name: String?
    let thumbnail: (path: String?, extension: String?)?
    let fav: Bool = false

    init(characterEntity: CharacterEntity) {
        self.id = characterEntity.id
        self.name = characterEntity.name
        self.thumbnail = characterEntity.thumbnail
        //Buscar si es fav
    }
}
