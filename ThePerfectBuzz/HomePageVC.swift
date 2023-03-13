//
//  ViewController.swift
//  ThePerfectBuzz
//
//  Created by Dane Jensen on 1/24/23.
//

import UIKit
import CoreData
var selectedDrink : DrinkCategory = DrinkCategory(name: "", image: UIImage(named: "Beer")!, averageProof: 0, color: .red, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [], sizes: [], sampleImages: [], drinkNames: []))


class HomePageVC : UIViewController {
    @IBOutlet weak var addDrinkBGView: UIView!
    @IBOutlet weak var topBGView: UIView!
    @IBOutlet weak var orangeProgress: UIView!
    
    @IBOutlet weak var currentDrinksTable: UITableView!
    @IBOutlet weak var currentDrinksView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var pointerPosition: NSLayoutConstraint!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var BACLabel: UILabel!
    @IBOutlet weak var drinkCollection: UICollectionView!
    @IBOutlet weak var pointerView: UIView!
    @IBOutlet weak var redProgress: UIView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    
    let Wine = DrinkCategory(name: "Wine", image: UIImage(named: "Wine")!, averageProof: 15, color: UIColor(named: "WineRed") ?? .red, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [10,12,15], sizes: [5, 10, 25], sampleImages: [UIImage(named: "WineSmall")!, UIImage(named: "WineMedium")!, UIImage(named: "WineLarge")!], drinkNames: ["Glass", "2 Glasses", "Bottle"]))
    
    
    let Beer = DrinkCategory(name: "Beer", image: UIImage(named: "Beer")!, averageProof: 5, color: UIColor(named: "BeerYellow") ?? .yellow, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [5, 6, 7], sizes: [12, 16, 33], sampleImages: [UIImage(named: "BeerSmall")!, UIImage(named: "BeerMedium")!, UIImage(named: "BeerLarge")!], drinkNames: ["Can", "Pint", "Liter"]))
    
    let Liquor = DrinkCategory(name: "Liquor", image: UIImage(named: "Liquor")!, averageProof: 20, color: UIColor(named: "LiquorBlue") ?? .blue, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [30, 35, 40], sizes: [1.5,3, 4.5], sampleImages: [UIImage(named: "ShotSmall")!, UIImage(named: "ShotMedium")!, UIImage(named: "ShotLarge")!], drinkNames: ["Glass", "2 Glasses", "Bottle"]))
    
    let Seltzer = DrinkCategory(name: "Seltzer", image: UIImage(named: "Seltzer")!, averageProof: 15, color: UIColor(named: "SeltzerTeal") ?? .systemTeal, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [5, 6, 7], sizes: [12, 16, 33], sampleImages: [UIImage(named: "BeerSmall")!, UIImage(named: "BeerMedium")!, UIImage(named: "BeerLarge")!], drinkNames: ["Glass", "2 Glasses", "Bottle"]))
    
    let Champagne = DrinkCategory(name: "Champagne", image: UIImage(named: "Champagne")!, averageProof: 15, color: UIColor(named: "ChampagnePink") ?? .systemPink, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [12, 15, 20], sizes: [4, 8, 25], sampleImages: [UIImage(named: "ChampagneSmall")!, UIImage(named: "ChampagneMedium")!, UIImage(named: "ChampagneLarge")!], drinkNames: ["Glass", "2 Glasses", "Bottle"]))
    
    let Custom = DrinkCategory(name: "Custom", image: UIImage(named: "Custom")!, averageProof: 0, color: UIColor(named: "CustomBrown") ?? .brown, drinkSelectionInfo: DrinkSelectionInfo(alcoholPercentages: [1,2,4], sizes: [1,2,3], sampleImages: [UIImage(named: "WineSmall")!, UIImage(named: "WineMedium")!, UIImage(named: "WineLarge")!], drinkNames: ["Glass", "2 Glasses", "Bottle"]))
    
    var DrinkCategories : [DrinkCategory] = []
    
    //let BeerToDrink = Drink(timeConsumed: Date() - (3600 * 3), percent: 0.045, volume: Measurement(value: 12, unit: UnitVolume.fluidOunces), name: "Test")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let UIUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            self.updateUI()
            currentUser.BAC = self.calculateBAC()
            print("Updating UI...")
        }
        
        viewHeight.constant = 1500
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleMyNotification(_:)), name: .kMyNotification, object: nil)
        
        DrinkCategories = [Liquor, Beer, Wine, Seltzer, Champagne, Custom]

        drinkCollection.dataSource = self
        drinkCollection.delegate = self
        
        setupBackgroundViews(viewtoChange: topBGView)
        setupBackgroundViews(viewtoChange: addDrinkBGView)
        setupBackgroundViews(viewtoChange: currentDrinksView)
        
        orangeProgress.roundCorners([.topLeft, .bottomLeft], radius: 10)
        redProgress.roundCorners([.topRight, .bottomRight], radius: 10)
        
        currentDrinksTable.delegate = self
        currentDrinksTable.dataSource = self
        
        currentDrinksTable.register(UINib(nibName: "DrinkTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinkCell")
        
        currentUser.BAC = calculateBAC()

        updateUI()
       /*
      
        */
    }
    
    @objc func handleMyNotification(_ sender: Notification) {
        currentUser.BAC = calculateBAC()
        print("Saving data")
        
        UserDefaults.standard.setCodableObject(currentUser, forKey: key)
      
        updateUI()
   }
    
    
    func convertBACtoSlider() -> Double {
        let screenWidth = UIScreen.main.bounds.width
        let totalLength = (screenWidth - 80)
        
        print(totalLength)

        let pointOnSlider = (totalLength) * (currentUser.BAC / 0.3)
        
        print("Point On Slider: \(pointOnSlider)")
        
        if pointOnSlider > totalLength {
            return totalLength
        }
        else if pointOnSlider == 0 {
            return (pointOnSlider + 10)
        }
        else {
            return pointOnSlider
        }
    }
 
    func playAnimation() {
        // Request a layout to clean pending changes for the view if there's any.
        self.view.layoutIfNeeded()
        
        // Make your constraint changes.
        self.pointerPosition.constant = self.convertBACtoSlider()

        UIView.animate(withDuration: 1.0) {
            // Let your constraint changes update right now.
            self.view.layoutIfNeeded()
        }
    }
    
    func updateUI() {
        var label = ""
        BACLabel.text = String((currentUser.BAC*1000).rounded()/1000)
        
        switch currentUser.BAC {
        case 0.00...0.03:
            label = "Normal Behavior"
        case 0.03...0.06 :
            label = "Mild Euphoria/Impairment"
        case 0.06...0.10:
            label = "Perfectly Buzzed"
        case 0.1...0.2:
            label = "Drunk, Slurred speech"
        case 0.2...0.3:
            label = "Blackout Drunk"
        default:
            label = ""
        }
        infoLabel.text = label
        
        DispatchQueue.main.async {
            self.currentDrinksTable.reloadData()

        }
        
        playAnimation()
    }

    func calculateBAC() -> Double {
        var totalBAC = 0.0
        var index = 0
        var keepSubtracting = true
        
        let sortedArray = currentUser.currentDrinks!.sorted(by: { $0.timeStarted.compare($1.timeStarted) == .orderedDescending })
        
        
        for drink in sortedArray {
            
            let timeSinceDrink = drink.timeStarted.timeIntervalSinceNow
            let intervalInHours = Double(timeSinceDrink.rounded() / -3600)
            var alcLevel = 0.0
            
            
            if keepSubtracting{
                 alcLevel = drink.alcLevel! - (currentUser.DrinkingFrequency * intervalInHours)
            }
            else {
                alcLevel = drink.alcLevel!
            }
            if (alcLevel < 0) {
                print("Removing Drink")
                currentUser.currentDrinks?.remove(at: index)
                index = index - 1
            }
            else {
                keepSubtracting = false
                totalBAC += alcLevel
            }
            index += 1
            
            /*
            print(drink)
            print("Interval: \(intervalInHours)")
            print("Alc Level: \(alcLevel)")
            print("BAC: \(totalBAC)")
            */
            
            
        }
        
        return totalBAC
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

extension HomePageVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return DrinkCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkCollectionViewCell", for: indexPath) as! DrinkCollectionViewCell
        
        cell.setupCell(with: DrinkCategories[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(DrinkCategories[indexPath.row].name)
        selectedDrink = DrinkCategories[indexPath.row]
        performSegue(withIdentifier: "DrinkFocus", sender: nil)
    }
}

extension  Notification.Name {
    public static let kMyNotification = Notification.Name("myNotification")
}


extension UserDefaults {
  func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
    let encoded = try? JSONEncoder().encode(data)
    set(encoded, forKey: defaultName)
  }
}
extension UserDefaults {
  func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
    guard let userDefaultData = data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: userDefaultData)
  }
}
extension HomePageVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return currentUser.currentDrinks?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as? DrinkTableViewCell else { return UITableViewCell() }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "h:mm a"
        
        if let drink = currentUser.currentDrinks?[indexPath.row] {
            cell.drinkName.text = drink.name
            cell.drinkTime.text = (dateFormatterGet.string(from: drink.timeStarted))
            cell.drinkImage.image = UIImage(named: drink.name)
            cell.drinkPercent.text = String(drink.percent * 100) + "%"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            currentUser.currentDrinks?.remove(at: indexPath.row)
            NotificationCenter.default.post(name: .kMyNotification, object: nil)

            
        }
    }

    
}
