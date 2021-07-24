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
    /*
     func refresh()
     func numberOfRowsInSection() -> Int
     func didSelectRowAt(index: Int)
     func deselectRowAt(index: Int)
     */
}

// MARK: Presenter -> View
protocol CharactersListPresenterToViewProtocol : AnyObject {
    func onGetCharacterListSuccess(scrollToTop: Bool)
    func onGetCharacterListFailure()
    func showNoResultsView()
    /*
     func onGetListSuccess()
     func onGetListFailure()
     func showHUD()
     func hideHUD()
     func deselectRowAt(row: Int)
     */
}

// MARK: Presenter -> Interactor
protocol CharactersListPresenterToInteractorProtocol {
    var presenter: CharactersListInteractorToPresenterProtocol? { get set }
    func getCharacterList(offset: Int, text: String?, newSearch: Bool)
    func getCharacterDetail(id: Int) -> CharacterEntity?
    /*
     func fetchQuotesSuccess(quotes: [APIQuote])
     func fetchQuotesFailure(errorCode: Int)
     func getQuoteSuccess(_ quote: APIQuote)
     func getQuoteFailure()
     */
}

// MARK: Interactor -> Presenter
protocol CharactersListInteractorToPresenterProtocol : AnyObject {
    func getCharacterListSuccess(characterList: [CharacterListModel], offset: Int, name: String?, apiMessage: String)
    func getCharacterListFailure()
    /*
     func fetchQuotesSuccess(quotes: [APIQuote])
     func fetchQuotesFailure(errorCode: Int)
     func getQuoteSuccess(_ quote: APIQuote)
     func getQuoteFailure()
     */
}

// MARK: Presenter -> Router
protocol CharactersListPresenterToRouterProtocol {
    func navigateToCharacterDetail(on view: CharactersListPresenterToViewProtocol?, character: CharacterEntity)
    /*

     */
}
