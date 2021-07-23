//
//  ItemCollectionModel.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 22/7/21.
//

class ItemCollectionModel {
    let available: Int?
    let items: [String]?

    init(itemCollection: ItemCollection) {
        self.available = itemCollection.available
        self.items = itemCollection.items?.map({$0.name ?? ""})
    }
}
