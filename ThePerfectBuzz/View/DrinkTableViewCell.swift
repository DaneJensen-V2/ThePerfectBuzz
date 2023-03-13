//
//  DrinkTableViewCell.swift
//  The Perfect Buzz
//
//  Created by Dane Jensen on 1/31/23.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkTime: UILabel!
    @IBOutlet weak var drinkPercent: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
