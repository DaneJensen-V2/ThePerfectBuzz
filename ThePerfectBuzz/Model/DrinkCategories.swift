//
//  DrinkCategories.swift
//  ThePerfectBuzz
//
//  Created by Dane Jensen on 1/25/23.
//

import Foundation
import UIKit


struct DrinkCategory {
    var name : String
    var image : UIImage
    var averageProof : Int
    var color : UIColor
    var drinkSelectionInfo : DrinkSelectionInfo
}

struct DrinkSelectionInfo {
    var alcoholPercentages : [Int]
    var sizes : [Double]
    var sampleImages : [UIImage]
    var drinkNames : [String]
}
