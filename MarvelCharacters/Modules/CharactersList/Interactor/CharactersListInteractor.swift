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

    var offsetRequested: Int = -1
    var requestInProcess: Bool = false

    func getCharacterList(offset: Int) {
        guard offset > self.offsetRequested, requestInProcess == false else {
            return
        }
        self.requestInProcess = true
        characterApiDataManager.fetchCharacterList(offset: offset, completion: { result  in
            self.requestInProcess = false
            switch result {
                case .success(let data):
                    guard let characterList = data.characters?.map({CharacterListModel(characterEntity: $0)}) else {
                        self.presenter?.getCharacterListFailure()
                        return
                    }
                    self.offsetRequested = offset
                    self.characterLocalDataManager.updateEntities(entities: data)
                    let offset = data.offset ?? 0
                    let apiMessage = data.attributedText ?? ""
                    self.presenter?.getCharacterListSuccess(characterList: characterList, offset: offset, apiMessage: apiMessage)
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
