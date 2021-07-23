//
//  CharactersListPresenter.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListPresenter: CharactersListViewToPresenterProtocol {

    weak var view: CharactersListPresenterToViewProtocol?
    var interactor: CharactersListPresenterToInteractorProtocol?
    var router: CharactersListPresenterToRouterProtocol?

    var characterList: [CharacterListModel]?
    var apiMessage: String?

    func viewDidLoad() {
        print("View is loaded")
        self.characterList = []
        interactor?.getCharacterList(offset: 0)
    }

    func numberOfRows() -> Int {
        return characterList?.count ?? 0
    }

    func characterAtIndex(index: IndexPath) -> CharacterListModel? {
        if characterList?.count ?? 0 > index.row {
            return characterList?[index.row]
        }
        return nil
    }

    func updateMaxIndex(index: Int) {
        let currentCharacterCount = characterList?.count ?? 0
        if index > currentCharacterCount - 10 {
            self.interactor?.getCharacterList(offset: currentCharacterCount)
        }
    }

    func characterSelectedAtIndex(index: IndexPath) {
        let character = characterAtIndex(index: index)
        if let characterDetail = self.interactor?.getCharacterDetail(id: character?.id ?? 0) {
            self.router?.navigateToCharacterDetail(on: self.view, character: characterDetail)
        } else {
            print("Character not found")
        }
    }

    func getApiUsageMesage() -> String {
        return self.apiMessage ?? ""
    }

}

extension CharactersListPresenter: CharactersListInteractorToPresenterProtocol {

    func getCharacterListSuccess(characterList: [CharacterListModel], offset:Int, apiMessage: String) {
        self.characterList?.append(contentsOf: characterList)
        self.apiMessage = apiMessage
        self.view?.onGetCharacterListSuccess()
    }

    func getCharacterListFailure() {
        //
    }

    
}
