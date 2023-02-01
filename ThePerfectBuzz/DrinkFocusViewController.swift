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

    @IBOutlet weak var startedDrinkingBG: UIView!
    @IBOutlet weak var amountSegment: UISegmentedControl!
    @IBOutlet weak var alcoholContentView: UIView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var drinklabel: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    var textFieldPosition = 0
    var amount = 0.0
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
        
        timePickerView.maximumDate = Date()
        
        amountSegment.subviews.flatMap{$0.subviews}.forEach { subview in
                if let imageView = subview as? UIImageView, imageView.frame.width > 5 {
                    imageView.contentMode = .scaleAspectFit
                }
            }
        
        alcoholContentSegment.font(name: "Poppins-Bold", size: 28)

    }
    
    func setAmountSegment(){
        amount = selectedDrink.drinkSelectionInfo.sizes[0]
        amountTextField.text = String(amount) + "oz"

        let images = selectedDrink.drinkSelectionInfo.sampleImages
        
        for x in 0...2 {
            amountSegment.setImage(images[x], forSegmentAt: x)
        }
        
    }
    
    @IBAction func amountSegment(_ sender: UISegmentedControl) {
        
        let amounts = selectedDrink.drinkSelectionInfo.sizes
        
        amount = amounts[amountSegment.selectedSegmentIndex]
      
        amountTextField.text = String(amount) + "oz"
    }
    
    @IBAction func editingStartAmount(_ sender: Any) {

        DispatchQueue.main.async { [self] in
            let arbitraryValue: Int = amountTextField.text!.count - 2
            print(arbitraryValue)
            if let newPosition = amountTextField.position(from: amountTextField.beginningOfDocument, offset: arbitraryValue) {
                
                amountTextField.selectedTextRange = amountTextField.textRange(from: newPosition, to: newPosition)
            }
        }

    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200
        
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        
    }
    
    @IBAction func percentEditBegin(_ sender: UITextField) {
        let arbitraryValue: Int = 0
        if let newPosition = alcoholContentTF.position(from: alcoholContentTF.beginningOfDocument, offset: arbitraryValue) {

            alcoholContentTF.selectedTextRange = alcoholContentTF.textRange(from: newPosition, to: newPosition)
        }
        alcoholContentTF.text = "%"
    }
    @IBAction func percentChanged(_ sender: UITextField) {
        if let amountString = alcoholContentTF.text?.percentFormatter() {
            
            alcoholContentTF.text = amountString
            let arbitraryValue: Int = amountString.count - 1
            
            if let newPosition = amountTextField.position(from: amountTextField.beginningOfDocument, offset: arbitraryValue) {

                amountTextField.selectedTextRange = amountTextField.textRange(from: newPosition, to: newPosition)
            }
            
            }
        }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true

    }

    @IBAction func amountChanged(_ sender: UITextField) {
        
        if let amountString = amountTextField.text?.currencyInputFormatting() {
           
            amountTextField.text = amountString
            let arbitraryValue: Int = amountString.count - 2
            
            if let newPosition = amountTextField.position(from: amountTextField.beginningOfDocument, offset: arbitraryValue) {

                amountTextField.selectedTextRange = amountTextField.textRange(from: newPosition, to: newPosition)
            }
            
            }
    }
    
    @IBAction func addDrinkClicked(_ sender: UIButton) {
        let amount = Double((amountTextField.text?.extractNumber())!)
        let percent = Double((alcoholContentTF.text?.extractNumber())!) / 100
        
        let newDrink = Drink(timeConsumed: timePickerView.date, percent:percent, volume: Measurement(value: amount, unit: UnitVolume.fluidOunces))
        
        currentUser.currentDrinks?.append(newDrink)
        NotificationCenter.default.post(name: .kMyNotification, object: nil)

        self.dismiss(animated: true)
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

    func extractNumber() -> Int {
        var intString = ""
        
        for char in self {
            if char.isNumber{
                intString += String(char)
            }
            else{
                break
            }
        }
        
        
        return Int(intString) ?? 0
    }
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 3
        
       
        
        let numString: NSNumber = NSNumber(value:  self.extractNumber())

        return (formatter.string(from: (numString)) ?? "") + "oz"

        
    }
    func percentFormatter() -> String {
    
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 2
        
        
        var intString = ""
        
        for char in self {
            if char.isNumber{
                intString += String(char)
            }
            else{
                break
            }
        }
        
        let numString: NSNumber = NSNumber(value: Int(intString) ?? 0)

                
        return (formatter.string(from: (numString)) ?? "") + "%"

        
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
