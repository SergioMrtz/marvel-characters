//
//  CharacterDetailModel.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

class CharacterDetailModel {

    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: (path: String?, extension: String?)?

    let comics: ItemCollectionModel?
    let series: ItemCollectionModel?
    let stories: ItemCollectionModel?
    let events: ItemCollectionModel?

    init(character: CharacterEntity) {
        self.id = character.id
        self.name = character.name
        self.description = character.description
        self.thumbnail = character.thumbnail

        if let comics = character.comics {
            self.comics = ItemCollectionModel(itemCollection: comics, type: .comics)
        } else {
            self.comics = nil
        }

        if let series = character.series {
            self.series = ItemCollectionModel(itemCollection: series, type: .series)
        } else {
            self.series = nil
        }
        if let events = character.events {
            self.events = ItemCollectionModel(itemCollection: events, type: .events)
        } else {
            self.events = nil
        }
        if let stories = character.stories {
            self.stories = ItemCollectionModel(itemCollection: stories, type: .stories)
        } else {
            self.stories = nil
        }
    }
    
}
