//
//  CharactersListProtocol.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

// MARK: View -> Presenter
protocol CharactersListViewToPresenterProtocol {
    var view: CharactersListPresenterToViewProtocol? { get set }
    var interactor: CharactersListPresenterToInteractorProtocol? { get set }
    var router: CharactersListPresenterToRouterProtocol? { get set }
    func viewDidLoad()
    func numberOfRows() -> Int
    func characterAtIndex(index: IndexPath) -> CharacterListModel?
    func updateMaxIndex(index: Int)
    func characterSelectedAtIndex(index: IndexPath)
    func getApiUsageMesage() -> String
    func searchBarTextChanged(with text: String)
}

// MARK: Presenter -> View
protocol CharactersListPresenterToViewProtocol : AnyObject {
    func onGetCharacterListSuccess(scrollToTop: Bool)
    func onGetCharacterListFailure(errorMessage: String)
    func showLoader()
    func showNoResultsView()
}

// MARK: Presenter -> Interactor
protocol CharactersListPresenterToInteractorProtocol {
    var presenter: CharactersListInteractorToPresenterProtocol? { get set }
    func getCharacterList(offset: Int, text: String?, newSearch: Bool)
    func getCharacterDetail(id: Int) -> CharacterEntity?
}

// MARK: Interactor -> Presenter
protocol CharactersListInteractorToPresenterProtocol : AnyObject {
    func getCharacterListSuccess(characterList: [CharacterListModel], offset: Int, name: String?, apiMessage: String)
    func getCharacterListFailure(error: MCErrorType)
}

// MARK: Presenter -> Router
protocol CharactersListPresenterToRouterProtocol {
    func navigateToCharacterDetail(on view: CharactersListPresenterToViewProtocol?, character: CharacterEntity)
}
