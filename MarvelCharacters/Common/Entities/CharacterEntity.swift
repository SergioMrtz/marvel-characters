//
//  CharacterEntity.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import Foundation
import SwiftyJSON


public struct CharactersListEntity {
    let total: Int?
    let count: Int?
    let offset: Int?
    let limit: Int?
    let attributedText: String?

    let characters: [CharacterEntity]?

    init(json: JSON) {
        self.attributedText = json["attributionText"].string
        self.total = json["data"]["total"].int
        self.count = json["data"]["count"].int
        self.offset = json["data"]["offset"].int
        self.limit = json["data"]["limit"].int

        self.characters = json["data"]["results"].array?.map{CharacterEntity(json: $0)}
    }
}

public struct CharacterEntity {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: (path: String?, extension: String?)?
    let resourceURI: String?

    let comics: ItemCollection?
    let series: ItemCollection?
    let stories: ItemCollection?
    let events: ItemCollection?

    let urls: [CharacterItemUrl]?

    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.description = json["description"].string
        self.modified = json["modified"].string
        self.thumbnail = (json["thumbnail"]["path"].string, json["thumbnail"]["extension"].string)
        self.resourceURI = json["resourceURI"].string

        self.comics = json["comics"].dictionary.map{ItemCollection(json: $0)}
        self.series = json["series"].dictionary.map{ItemCollection(json: $0)}
        self.stories = json["stories"].dictionary.map{ItemCollection(json: $0)}
        self.events = json["comics"].dictionary.map{ItemCollection(json: $0)}

        self.urls = json["urls"].array?.map{CharacterItemUrl(json: $0)}
    }
}

public struct ItemCollection {
    let available: Int?
    let collectionURI: String?
    let returned: Int?
    let items: [ItemCollectionElement]?

    init(json: [String : JSON]?) {
        self.available = json?["available"]?.int
        self.collectionURI = json?["collectionURI"]?.string
        self.returned = json?["returned"]?.int

        self.items = json?["items"]?.array?.map{ItemCollectionElement(json: $0)}
    }
}

public struct ItemCollectionElement {
    let resourceURI: String?
    let name: String?
    let type: String?

    init(json: JSON) {
        self.resourceURI = json["resourceURI"].string
        self.name = json["name"].string
        self.type = json["type"].string
    }
}

public struct CharacterItemUrl {
    let type: String?
    let url: String?

    init(json: JSON) {
        self.type = json["type"].string
        self.url = json["url"].string
    }
}
