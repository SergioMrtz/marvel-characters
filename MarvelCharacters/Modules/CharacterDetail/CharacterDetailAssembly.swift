//
//  CharacterDetailAssembly.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 20/7/21.
//

import UIKit

class CharacterDetailAssembly {

    static func buildModule(with character: CharacterEntity) -> CharacterDetailViewController {
        let view = CharacterDetailViewController()
        let presenter = CharacterDetailPresenter()
        let interactor = CharacterDetailInteractor()
        let router = CharacterDetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        //router.presenter = presenter

        let characterDetailModel = CharacterDetailModel(character: character)
        presenter.character = characterDetailModel

        return view
    }

}
