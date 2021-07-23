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
    }

}
