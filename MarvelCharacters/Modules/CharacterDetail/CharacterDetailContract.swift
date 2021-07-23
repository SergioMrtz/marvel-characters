//
//  CharacterDetailProtocol.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

// MARK: View -> Presenter
protocol CharacterDetailViewToPresenterProtocol {
    var view: CharacterDetailPresenterToViewProtocol? { get set }
    var interactor: CharacterDetailPresenterToInteractorProtocol? { get set }
    var router: CharacterDetailPresenterToRouterProtocol? { get set }
    func viewDidLoad()
    /*
     func refresh()
     func numberOfRowsInSection() -> Int
     func didSelectRowAt(index: Int)
     func deselectRowAt(index: Int)
     */
}

// MARK: Presenter -> View
protocol CharacterDetailPresenterToViewProtocol : AnyObject {
    /*
     func onGetListSuccess()
     func onGetListFailure()
     func showHUD()
     func hideHUD()
     func deselectRowAt(row: Int)
     */
}

// MARK: Presenter -> Interactor
protocol CharacterDetailPresenterToInteractorProtocol {
    var presenter: CharacterDetailInteractorToPresenterProtocol? { get set }
    /*
     func fetchQuotesSuccess(quotes: [APIQuote])
     func fetchQuotesFailure(errorCode: Int)
     func getQuoteSuccess(_ quote: APIQuote)
     func getQuoteFailure()
     */
}

// MARK: Interactor -> Presenter
protocol CharacterDetailInteractorToPresenterProtocol : AnyObject {
    /*
     func fetchQuotesSuccess(quotes: [APIQuote])
     func fetchQuotesFailure(errorCode: Int)
     func getQuoteSuccess(_ quote: APIQuote)
     func getQuoteFailure()
     */
}

// MARK: Presenter -> Router
protocol CharacterDetailPresenterToRouterProtocol {
    /*

     */
}
