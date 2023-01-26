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
        
    }
}
