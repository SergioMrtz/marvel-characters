//
//  ItemCollectionView.swift
//  marvelCharacters
//
//  Created by Sergio Martínez Muñoz on 22/7/21.
//

import UIKit

class ItemCollectionView : UIView {

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var itemsCollectionView: UICollectionView!

    var items: [String]?
    var available: Int?
    var type: CollectionType?
    var image: UIImage?

    var cellIdentifier = "ItemCollectionViewCell"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeNib()
    }

    func initializeNib() {
        let view = Bundle.main.loadNibNamed("ItemCollectionView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)

        self.itemsCollectionView.dataSource = self
        self.itemsCollectionView.delegate = self
        self.itemsCollectionView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
    }

    func configure(with itemCollection: ItemCollectionModel) {
        self.items = itemCollection.items
        self.available = itemCollection.available
        self.type = itemCollection.type

        self.updateViews()
    }

    func updateViews() {
        if let available = self.available {
            let titleString = self.type!.rawValue + " (\(available))"
            self.labelTitle.text = titleString
        }
    }

    func refreshImages(with image: UIImage?) {
        self.image = image
        self.itemsCollectionView.reloadData()
    }

}

extension ItemCollectionView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 128.0)
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.configureCell(with: self.items?[indexPath.row] ?? "", image: self.image)
        return cell
    }


}
