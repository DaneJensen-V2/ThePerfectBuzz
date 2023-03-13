//
//  DrinkFocusViewController.swift
//  The Perfect Buzz
//
//  Created by Dane Jensen on 1/26/23.
//

import UIKit

class DrinkFocusViewController: UIViewController {

    @IBOutlet weak var alcoholContentTF: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addDrinkButton: UIButton!
    @IBOutlet weak var alcoholContentSegment: UISegmentedControl!

    @IBOutlet weak var amountLabel3: UILabel!
    @IBOutlet weak var amountLabel2: UILabel!
    @IBOutlet weak var amountLabel1: UILabel!
    @IBOutlet weak var startedDrinkingBG: UIView!
    @IBOutlet weak var amountSegment: UISegmentedControl!
    @IBOutlet weak var alcoholContentView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var drinklabel: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    var textFieldPosition = 0
    var amount = 0.0
    var percent = 0.0
    
    let generator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        view.backgroundColor = selectedDrink.color
        drinkImage.image = selectedDrink.image
        drinklabel.text = selectedDrink.name
        setupBackgroundViews(viewtoChange: sizeView)
        setupBackgroundViews(viewtoChange: alcoholContentView)
        setupBackgroundViews(viewtoChange: startedDrinkingBG)
        addDrinkButton.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()

        
        setAmountSegment()
        setPercentSegment()
        
        timePickerView.maximumDate = Date()
        
        amountSegment.subviews.flatMap{$0.subviews}.forEach { subview in
                if let imageView = subview as? UIImageView, imageView.frame.width > 5 {
                    imageView.contentMode = .scaleAspectFit
                }
            }
        
        alcoholContentSegment.font(name: "Poppins-Bold", size: 28)

    }
    
    func setAmountSegment(){
        let labels = selectedDrink.drinkSelectionInfo.drinkNames
        amountLabel1.text = labels[0]
        amountLabel2.text = labels[1]
        amountLabel3.text = labels[2]

        amount = selectedDrink.drinkSelectionInfo.sizes[0]
        amountTextField.text = String(Int(amount)) + "oz"

        let images = selectedDrink.drinkSelectionInfo.sampleImages
        
        for x in 0...2 {
            amountSegment.setImage(images[x], forSegmentAt: x)
        }
        
    }
    
    @IBAction func amountSegment(_ sender: UISegmentedControl) {
        
        let amounts = selectedDrink.drinkSelectionInfo.sizes
    
        amount = amounts[amountSegment.selectedSegmentIndex]
      
        amountTextField.text = String(Int(amount)) + "oz"
        
        generator.impactOccurred()

    }
    
    func setPercentSegment(){
        let percentages = selectedDrink.drinkSelectionInfo.alcoholPercentages

        percent = percentages[0]
        alcoholContentTF.text = String(percent) + "%"

        
        for x in 0...2 {
            alcoholContentSegment.setTitle(String(Int(percentages[x])) + "%", forSegmentAt: x)
        }
    }
    
  
    @IBAction func alcPercentChanged(_ sender: UISegmentedControl) {
        let percents = selectedDrink.drinkSelectionInfo.alcoholPercentages

        percent = percents[alcoholContentSegment.selectedSegmentIndex]
      

        alcoholContentTF.text = String(percent) + "%"
        generator.impactOccurred()

    }
   
 
   
    

    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200
        
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        
    }
    
    @IBAction func amountEditBegin(_ sender: UITextField) {
        print("BEGIN Amount")
        sender.text = ""
    }
    @IBAction func amountEditEnd(_ sender: UITextField) {
        amountTextField.text = amountTextField.text?.currencyInputFormatting()
    }
    
    
    @IBAction func percentBeginEditing(_ sender: UITextField) {
        print("BEGIN")
        sender.text = ""
    }
    @IBAction func alcPercentEnded(_ sender: Any) {
       print("ended")
        
        alcoholContentTF.text = alcoholContentTF.text?.percentFormatter()
            
            
    }
    
    
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true

    }

    func tooManyDrinks() {
        let alert = UIAlertController(title: "Too Many Drinks", message: "You can input a max of 20 drinks at a time.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("Too many drinks")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addDrinkClicked(_ sender: UIButton) {
        
        if currentUser.currentDrinks!.count >= 5 {
            tooManyDrinks()
        }
        
        else {
            
            
            let amount = Double((amountTextField.text?.extractNumber())!)
            let percent = Double((alcoholContentTF.text?.extractNumber())!) / 100
            
            let newDrink = Drink(timeConsumed: timePickerView.date, percent:percent, volume: Measurement(value: amount, unit: UnitVolume.fluidOunces), name: selectedDrink.name)
            
            currentUser.currentDrinks?.append(newDrink)
            NotificationCenter.default.post(name: .kMyNotification, object: nil)
            
            self.dismiss(animated: true)
        }
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

extension UISegmentedControl {
    func font(name:String?, size:CGFloat?) {
        let attributedSegmentFont = NSDictionary(object: UIFont(name: name!, size: size!)!, forKey: NSAttributedString.Key.font as NSCopying)
        setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: .normal)
    }
}

extension String {

    func extractNumber() -> Double {
        var intString = ""
        
        for char in self {
            if char.isNumber{
                intString += String(char)
            }
            else if char == "." {
                intString += String(char)
            }
            else{
                break
            }
        }
        
        print(intString)
        return Double(intString) ?? 0.0
    }
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 1
        
       
        if let doubleValue = Double(self) {
         
            return formatter.string(from: NSNumber(value: doubleValue))! + "oz"

        }
        else {
            return formatter.string(from: NSNumber(value: 0))! + "oz"
        }
        


        
    }
    func percentFormatter() -> String {
    
        print(self)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 1
        
     
        if let doubleValue = Double(self) {
         
            return formatter.string(from: NSNumber(value: doubleValue/100))!

        }
        else {
            return formatter.string(from: NSNumber(value: 0))!
        }
        

        
    }
}
extension UIViewController {

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
