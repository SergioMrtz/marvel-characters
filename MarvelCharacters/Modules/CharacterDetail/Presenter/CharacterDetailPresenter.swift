//
//  CharacterDetailPresenter.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharacterDetailPresenter: CharacterDetailViewToPresenterProtocol {
    
    weak var view: CharacterDetailPresenterToViewProtocol?
    var interactor: CharacterDetailPresenterToInteractorProtocol?
    var router: CharacterDetailPresenterToRouterProtocol?

    var character: CharacterDetailModel?

    func viewDidLoad() {
        if let character = self.character {
            self.view?.updateView(with: character)
        }
    }
}

extension CharacterDetailPresenter: CharacterDetailInteractorToPresenterProtocol {
}


