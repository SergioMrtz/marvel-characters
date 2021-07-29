//
//  CharactersListPresenter.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListPresenter {


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

    private func performSearch(offset: Int, text: String?, isNewSearch: Bool) {
        self.requestInProgress = true
        interactor?.getCharacterList(offset: offset, text: text, newSearch: isNewSearch)
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
            self.view?.showLoader()
            self.performSearch(offset: self.offsetRequested, text: searchBarText, isNewSearch: true)
        }
        print("Search \(self.searchBarTimer!.userInfo as! String)")
    }
}

/// MARK: ViewController -> Presenter
extension CharactersListPresenter: CharactersListViewToPresenterProtocol {

    func viewDidLoad() {
        self.characterList = []
        self.performSearch(offset: 0, text: nil, isNewSearch: true)
    }

    func numberOfRows() -> Int {
        return characterList?.count ?? 0
    }

    // Retrieves info for a character at a given index
    func characterAtIndex(index: IndexPath) -> CharacterListModel? {
        if characterList?.count ?? 0 > index.row {
            return characterList?[index.row]
        }
        return nil
    }

    // Called each time the user scrolls to a position further down into the table view to check if it's neccessary to fetch more info
    func updateMaxIndex(index: Int) {
        let currentCharacterCount = characterList?.count ?? 0
        // When the tableView index is less than the character count minus 10 (only 10 characters left to scroll) a new search to fetch new characters is made
        if index > currentCharacterCount - 10 {
            guard (currentCharacterCount > self.offsetRequested), self.requestInProgress == false else {
                return
            }
            self.performSearch(offset: currentCharacterCount, text: self.searchBarText, isNewSearch: false)
        }
    }

    // User taps on a character cell
    func characterSelectedAtIndex(index: IndexPath) {
        let character = characterAtIndex(index: index)
        if let characterDetail = self.interactor?.getCharacterDetail(id: character?.id ?? 0) {
            self.router?.navigateToCharacterDetail(on: self.view, character: characterDetail)
        } else {
            print("ERROR - Character not found")
        }
    }

    func getApiUsageMesage() -> String {
        return self.apiMessage ?? ""
    }

    // User writes a new character in the searchBar
    func searchBarTextChanged(with text: String) {
        // Each time the user types in a character a timer starts. After 1 second it triggers a search using the string in the search bar.
        // The 1 second margin is used in order to not perform unneccessary requests if the user is still typing and provide a more user-friendly experience
        self.searchBarTimer?.invalidate()
            self.searchBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.performSearchTextChanged), userInfo: text, repeats: false)
        }

}

/// MARK: Interactor -> Presenter
extension CharactersListPresenter: CharactersListInteractorToPresenterProtocol {

    func getCharacterListSuccess(characterList: [CharacterListModel], offset:Int, name: String?, apiMessage: String) {
        self.requestInProgress = false

        // Update values for last successful request
        self.offsetRequested = offset
        self.lastTextRequested = name

        // In case of a new search (different searchBar string) the table will reset and scroll to the top of the list
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

    func getCharacterListFailure(error: MCErrorType) {
        self.requestInProgress = false
        let message = self.getErrorMessage(error: error)
        self.view?.onGetCharacterListFailure(errorMessage: message)
    }

    private func getErrorMessage(error: MCErrorType) -> String {
        var message = "Sorry, an error occurred: "
        switch error {
        case .unathorized:
            message.append("invalid api credentials.")
        case .serverError:
            message.append("server error.")
        case .resourceNotFound:
            message.append("resource not found.")
        case .incorrectParameters:
            message.append("invalid parameters.")
        case .incorrectData:
            message.append("invalid data.")
        case .noConnection:
            message.append("please check your connection.")
        default:
            message.append("unknown error.")
        }
        return message
    }
    
}
