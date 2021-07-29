//
//  CharacterDetailViewController.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 19/7/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    var presenter: CharacterDetailViewToPresenterProtocol?

    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterNameLabel: UILabel!

    @IBOutlet var characterDescriptionView: UIView!
    @IBOutlet var characterDescriptionTitleLabel: UILabel!
    @IBOutlet var characterDescriptionBodyLabel: UILabel!

    @IBOutlet var comicsColletion: ItemCollectionView!
    @IBOutlet var seriesCollection: ItemCollectionView!
    @IBOutlet var storiesCollection: ItemCollectionView!
    @IBOutlet var eventsCollection: ItemCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characterNameLabel.text = ""
        self.characterDescriptionBodyLabel.text = ""
        self.configureNavigationBar()
        self.presenter?.viewDidLoad()
    }

    private func hideView(_ view: UIView) {
        view.isHidden = true
        let zeroHeightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
        view.addConstraint(zeroHeightConstraint)
    }

}

/// MARK: Presenter -> ViewController
extension CharacterDetailViewController: CharacterDetailPresenterToViewProtocol {

    func updateView(with character: CharacterDetailModel) {

        // Name
        if let name = character.name {
            self.characterNameLabel.text = name
            self.navigationItem.title = name
        }

        // Description
        if let description = character.description, description != "" {
            self.characterDescriptionBodyLabel.text = description
        } else {
            self.hideView(self.characterDescriptionView)
        }

        // Collections (comics, series, etc)
        // Comics
        if let comics = character.comics, comics.items?.count ?? 0 > 0 {
            self.comicsColletion.configure(with: comics)
        } else {
            self.hideView(self.comicsColletion)
        }

        // Series
        if let series = character.series, series.items?.count ?? 0 > 0 {
            self.seriesCollection.configure(with: series)
        } else {
            self.hideView(self.seriesCollection)
        }

        // Stories
        if let stories = character.stories, stories.items?.count ?? 0 > 0 {
            self.storiesCollection.configure(with: stories)
        } else {
            self.hideView(self.storiesCollection)
        }

        // Events
        if let events = character.events, events.items?.count ?? 0 > 0 {
            self.eventsCollection.configure(with: events)
        } else {
            self.hideView(self.eventsCollection)
        }

        //Image
        self.getCharacterImage(from: character.thumbnail)
    }

    private func getCharacterImage(from thumbnail: (path: String?, extension: String?)?) {
        if let thumbnail = thumbnail, let imgPath = thumbnail.path, let imgExtension = thumbnail.extension {
            let urlString = imgPath.replacingOccurrences(of: "http", with: "https") + "/standard_large." + imgExtension
            guard let url = URL(string: urlString) else {
                return
            }
            let group = DispatchGroup()
            group.enter()
            self.characterImageView?.load(url: url, dispatchGroup: group)
            group.notify(queue: .main) {
                self.comicsColletion.refreshImages(with: self.characterImageView.image)
                self.eventsCollection.refreshImages(with: self.characterImageView.image)
                self.seriesCollection.refreshImages(with: self.characterImageView.image)
                self.storiesCollection.refreshImages(with: self.characterImageView.image)
            }
        }
    }
}

/// MARK: NavigationBar
extension CharacterDetailViewController {

    func configureNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = []
    }
}
