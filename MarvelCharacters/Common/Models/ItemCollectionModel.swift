//
//  ItemCollectionModel.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 22/7/21.
//

class ItemCollectionModel {
    let available: Int?
    let items: [String]?
    let type: CollectionType

    init(itemCollection: ItemCollection, type: CollectionType) {
        self.available = itemCollection.available
        self.items = itemCollection.items?.map({$0.name ?? ""})
        self.type = type
    }
}

enum CollectionType : String {
    case comics = "Comics"
    case events = "Events"
    case series = "Series"
    case stories = "Stories"
}
