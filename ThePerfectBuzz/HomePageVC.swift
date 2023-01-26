//
//  ViewController.swift
//  ThePerfectBuzz
//
//  Created by Dane Jensen on 1/24/23.
//

import UIKit

class HomePageVC : UIViewController {
    @IBOutlet weak var addDrinkBGView: UIView!
    @IBOutlet weak var topBGView: UIView!
    @IBOutlet weak var orangeProgress: UIView!
    
    @IBOutlet weak var drinkCollection: UICollectionView!
    @IBOutlet weak var pointerView: UIView!
    @IBOutlet weak var redProgress: UIView!
    
    let Wine = DrinkCategory(name: "Wine", image: UIImage(named: "Wine")!, averageProof: 15, color: UIColor(named: "WineRed") ?? .red)
    let Beer = DrinkCategory(name: "Beer", image: UIImage(named: "Beer")!, averageProof: 5, color: UIColor(named: "BeerYellow") ?? .yellow)
    let Liquor = DrinkCategory(name: "Liquor", image: UIImage(named: "Liquor")!, averageProof: 20, color: UIColor(named: "LiquorBlue") ?? .blue)
    let Seltzer = DrinkCategory(name: "Seltzer", image: UIImage(named: "Seltzer")!, averageProof: 15, color: UIColor(named: "SeltzerTeal") ?? .systemTeal)
    let Champagne = DrinkCategory(name: "Champagne", image: UIImage(named: "Champagne")!, averageProof: 15, color: UIColor(named: "ChampagnePink") ?? .systemPink)
    let Custom = DrinkCategory(name: "Custom", image: UIImage(named: "Custom")!, averageProof: 0, color: UIColor(named: "CustomBrown") ?? .brown)

    var DrinkCategories : [DrinkCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DrinkCategories = [Wine, Beer, Liquor, Seltzer, Champagne, Custom]

        drinkCollection.dataSource = self
        
        setupBackgroundViews(viewtoChange: topBGView)
        setupBackgroundViews(viewtoChange: addDrinkBGView)
        
        orangeProgress.roundCorners([.topLeft, .bottomLeft], radius: 10)
        redProgress.roundCorners([.topRight, .bottomRight], radius: 10)
        
       /*
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            
            let moveLeft = CGAffineTransform(translationX: -(self.view.bounds.width * 0.7), y: 0.0)
            self.pointerView.transform = moveLeft
        })
        */
    }


    
    
    func setupBackgroundViews(viewtoChange view : UIView){
        //Add Corner Radius
        view.layer.cornerRadius = 15
        
        //Add Shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 4.0
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}

extension HomePageVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return DrinkCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkCollectionViewCell", for: indexPath) as! DrinkCollectionViewCell
        
        cell.setupCell(with: DrinkCategories[indexPath.row])
        
        return cell
    }
    func collectionView(_: UICollectionView, didSelectItemAt: IndexPath) {
         print("Test")
    }
    
}
