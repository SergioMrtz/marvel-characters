//
//  CharacterDetailPresenter.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharacterDetailPresenter {
    
    weak var view: CharacterDetailPresenterToViewProtocol?
    var interactor: CharacterDetailPresenterToInteractorProtocol?
    var router: CharacterDetailPresenterToRouterProtocol?

    var character: CharacterDetailModel?
}

/// MARK: View -> Presenter
extension CharacterDetailPresenter: CharacterDetailViewToPresenterProtocol {
    func viewDidLoad() {
        if let character = self.character {
            self.view?.updateView(with: character)
        }
    }
}

/// MARK: Interactor -> Presenter
extension CharacterDetailPresenter: CharacterDetailInteractorToPresenterProtocol {
}

