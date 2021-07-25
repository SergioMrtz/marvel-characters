//
//  ItemCollectionViewCell.swift
//  iOS App
//
//  Created by Sergio Martínez Muñoz on 23/7/21.
//

import UIKit

class ItemCollectionViewCell : UICollectionViewCell {

    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        self.itemImage.image = nil
        self.itemTitleLabel.text = ""
        self.itemTitleLabel.textColor = .label
        self.itemTitleLabel.font = self.itemTitleLabel.font.withSize(13)
        self.itemImage.backgroundColor = .systemBackground
    }

    func configureCell(with item: String, image: UIImage?) {
        self.itemTitleLabel.text = item
        if let image = image {
            self.itemImage.image = image
        }
    }
}
