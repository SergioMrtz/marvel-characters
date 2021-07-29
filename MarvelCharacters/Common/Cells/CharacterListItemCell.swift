//
//  CharacterListItemCell.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 21/7/21.
//

import UIKit

class CharacterListItemCell: UITableViewCell {

    @IBOutlet var characterPortraitImageView: UIImageView!
    @IBOutlet var characterNameLabel: UILabel!

    var id: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        self.id = nil
        self.characterNameLabel.text = nil
        self.characterPortraitImageView.image = nil
    }

    func configureCell(character: CharacterListModel) {
        self.characterNameLabel.text = character.name
        self.id = character.id
        self.setupCharacterImage(thumbnail: character.thumbnail)
    }

    private func setupCharacterImage(thumbnail: (path: String?, extension: String?)?) {
        // imageview tag is used to check if the cell still is showing the same character when the image is loaded
        self.characterPortraitImageView.tag = self.id ?? -1
        if let imgPath = thumbnail?.path, let imgExtension = thumbnail?.extension {
            let urlString = imgPath.replacingOccurrences(of: "http", with: "https") + "/portrait_small." + imgExtension
            guard let url = URL(string: urlString) else {
                return
            }
            self.characterPortraitImageView?.load(url: url)
        }
    }

}

extension UIImageView {

    func load(url: URL, dispatchGroup: DispatchGroup? = nil) {
        let tag = self.tag
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if tag == self?.tag {
                                self?.image = image
                            }
                            dispatchGroup?.leave()
                        }
                    }
                }
            }
        }
}
