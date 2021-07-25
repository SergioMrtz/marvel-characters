//
//  CharactersListInteractor.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListInteractor: CharactersListPresenterToInteractorProtocol {

    weak var presenter: CharactersListInteractorToPresenterProtocol?

    var characterApiDataManager = CharacterApiDataManager()
    var characterLocalDataManager = LocalDataManager()

    func getCharacterList(offset: Int, text: String? = nil, newSearch: Bool) {

        characterApiDataManager.fetchCharacterList(offset: offset,
                                                   nameStartsWith: text,
                                                   completion: { result  in
            switch result {
                case .success(let data):
                    guard let characterList = data.characters?.map({CharacterListModel(characterEntity: $0)}) else {
                        self.presenter?.getCharacterListFailure()
                        return
                    }
                    if newSearch {
                        self.characterLocalDataManager.clearEntities()
                    }
                    self.characterLocalDataManager.updateEntities(entities: data)
                    let dataOffset = data.offset ?? 0
                    let apiMessage = data.attributedText ?? ""
                    self.presenter?.getCharacterListSuccess(characterList: characterList,
                                                            offset: dataOffset,
                                                            name: text,
                                                            apiMessage: apiMessage)
                case .failure(let failure):
                    self.presenter?.getCharacterListFailure()
            }
        })
    }


    func getCharacterDetail(id: Int) -> CharacterEntity? {
        let characterDetail = self.characterLocalDataManager.getCharacter(id: id)
        return characterDetail
    }
}
