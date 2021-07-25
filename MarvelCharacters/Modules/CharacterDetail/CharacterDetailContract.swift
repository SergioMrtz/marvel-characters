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
}

// MARK: Presenter -> View
protocol CharacterDetailPresenterToViewProtocol : AnyObject {
    func updateView(with character: CharacterDetailModel)
}

// MARK: Presenter -> Interactor
protocol CharacterDetailPresenterToInteractorProtocol {
    var presenter: CharacterDetailInteractorToPresenterProtocol? { get set }
}

// MARK: Interactor -> Presenter
protocol CharacterDetailInteractorToPresenterProtocol : AnyObject {
}

// MARK: Presenter -> Router
protocol CharacterDetailPresenterToRouterProtocol {
}
