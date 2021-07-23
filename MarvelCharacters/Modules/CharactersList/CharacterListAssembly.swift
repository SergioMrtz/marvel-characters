//
//  CharacterListAssembly.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 20/7/21.
//

import UIKit

class CharacterListAssembly {

    static func buildModule() -> CharactersListViewController {
        let view = CharactersListViewController()
        let presenter = CharactersListPresenter()
        let interactor = CharactersListInteractor()
        let router = CharactersListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
