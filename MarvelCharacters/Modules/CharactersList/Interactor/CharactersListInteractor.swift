//
//  CharactersListInteractor.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListInteractor {

    weak var presenter: CharactersListInteractorToPresenterProtocol?

    var characterApiDataManager = CharacterApiDataManager()
    var characterLocalDataManager = LocalDataManager()

}

/// MARK - Presenter -> Interactor
extension CharactersListInteractor: CharactersListPresenterToInteractorProtocol {

    // Fetch list of characters starting by "text" and with a given offset
    func getCharacterList(offset: Int, text: String? = nil, newSearch: Bool) {

        characterApiDataManager.fetchCharacterList(offset: offset,
                                                   nameStartsWith: text,
                                                   completion: { result  in
            switch result {
                case .success(let data):
                    guard let characterList = data.characters?.map({CharacterListModel(characterEntity: $0)}) else {
                        self.presenter?.getCharacterListFailure(error: MCErrorType.incorrectData)
                        return
                    }

                    // In case of a new list the characters are reset
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

                case .failure(let error):
                    self.presenter?.getCharacterListFailure(error: error)
            }
        })
    }

    // Fetch infor for a specific character with a given ID
    func getCharacterDetail(id: Int) -> CharacterEntity? {
        let characterDetail = self.characterLocalDataManager.getCharacter(id: id)
        return characterDetail
    }

}
