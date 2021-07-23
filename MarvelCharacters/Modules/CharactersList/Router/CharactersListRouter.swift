//
//  CharactersListRouter.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharactersListRouter: CharactersListPresenterToRouterProtocol {

    func navigateToCharacterDetail(on view: CharactersListPresenterToViewProtocol?, character: CharacterEntity) {
        let characterDetailViewController = CharacterDetailAssembly.buildModule(with: character)
        let viewController = view as! CharactersListViewController
        viewController.navigationController?.pushViewController(characterDetailViewController, animated: true)
    }


    func navigateToCharacterDetail(character: CharacterEntity) {
    }
    
}
