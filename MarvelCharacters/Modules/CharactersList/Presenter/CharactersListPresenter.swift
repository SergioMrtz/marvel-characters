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

    var searchBarTimer: Timer?
    var searchBarText: String?

    var lastTextRequested: String?
    var offsetRequested: Int = -1

    var requestInProgress: Bool?

    func viewDidLoad() {
        print("View is loaded")
        self.characterList = []
        interactor?.getCharacterList(offset: 0, text: nil, newSearch: true)
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
            guard (currentCharacterCount > self.offsetRequested), self.requestInProgress == false else {
                return
            }
            self.requestInProgress = true
            //self.view?.showLoader()
            self.interactor?.getCharacterList(offset: currentCharacterCount, text: self.searchBarText, newSearch: false)
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

    func searchBarTextChanged(with text: String) {
        self.searchBarTimer?.invalidate()
            self.searchBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.performSearchTextChanged), userInfo: text, repeats: false)
        }

    @objc func performSearchTextChanged() {
        if let searchBarText = self.searchBarTimer?.userInfo as? String {

            var newText: Bool = false
            if searchBarText != self.lastTextRequested {
                newText = true
            }
            guard self.requestInProgress == false, newText else {
                return
            }
            self.offsetRequested = 0
            self.requestInProgress = true
            self.view?.showLoader()
            self.interactor?.getCharacterList(offset: 0, text: searchBarText, newSearch: true)
        }
        print("Search \(self.searchBarTimer!.userInfo as! String)")
    }

}

extension CharactersListPresenter: CharactersListInteractorToPresenterProtocol {

    func getCharacterListSuccess(characterList: [CharacterListModel], offset:Int, name: String?, apiMessage: String) {
        self.requestInProgress = false

        self.offsetRequested = offset
        self.lastTextRequested = name

        var needsToResetToTop = false
        if let name = name, name != self.searchBarText {
            self.searchBarText = name
            self.characterList?.removeAll()
            needsToResetToTop = true
        }
        self.characterList?.append(contentsOf: characterList)
        if self.characterList?.count ?? 0 > 0 {
            self.apiMessage = apiMessage
            self.view?.onGetCharacterListSuccess(scrollToTop: needsToResetToTop)
        } else {
            self.view?.showNoResultsView()
        }
    }

    func getCharacterListFailure() {
        self.requestInProgress = false
        self.view?.onGetCharacterListFailure()
    }

    
}
