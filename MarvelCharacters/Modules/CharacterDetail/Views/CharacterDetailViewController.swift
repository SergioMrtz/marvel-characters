//
//  CharacterDetailViewController.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    var presenter: CharacterDetailViewToPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
    }

}

extension CharacterDetailViewController: CharacterDetailPresenterToViewProtocol {

}


extension CharacterDetailViewController {

    func configureNavigationBar() {
        self.navigationItem.title = "Name"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = []
    }
}
