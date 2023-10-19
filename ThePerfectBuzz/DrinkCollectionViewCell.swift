//
//  DrinkCollectionViewCell.swift
//  ThePerfectBuzz
//
//  Created by Dane Jensen on 1/25/23.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var drinkName: UILabel!
    
    func setupCell(with drink : DrinkCategory) {
        drinkImage.image = drink.image
        drinkName.text = drink.name
        bgView.backgroundColor = drink.color
        
        bgView.layer.cornerRadius = 10
        
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }
}
