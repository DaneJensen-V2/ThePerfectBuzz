//
//  UserData.swift
//  The Perfect Buzz
//
//  Created by Dane Jensen on 1/26/23.
//

import Foundation

let key = "user_key"

var currentUser = User(height: Measurement(value: 70, unit: UnitLength.inches), weight: Measurement(value: 180, unit: UnitMass.pounds), gender: .Male, DrinkingFrequency: 0.017, BAC: 0.0, currentDrinks: [])

   struct User : Codable {
    var height : Measurement<UnitLength>
    var weight : Measurement<UnitMass>
    var gender : Gender
    var DrinkingFrequency : Double
    var BAC : Double
    var userBACProduction : Double?
    var currentDrinks : [Drink]?
    
    init(height: Measurement<UnitLength>, weight: Measurement<UnitMass>, gender: Gender, DrinkingFrequency: Double, BAC: Double, currentDrinks: [Drink]) {
        self.height = height
        self.weight = weight
        self.gender = gender
        self.DrinkingFrequency = DrinkingFrequency
        self.BAC = BAC
        self.currentDrinks = currentDrinks
        
        self.userBACProduction = calculateBACProduction()
    }
    
       enum Gender : Codable{
        case Male
        case Female
    }
    enum Frequency : Double, Codable{
        case average = 0.017
        case aboveAverage = 0.02
        case belowAverage = 0.012
    }
    
   
    func calculateBACProduction() -> Double {
     
    let genderConstant = (gender == .Male) ? 0.58 : 0.49
        
    let mass = weight.converted(to: .kilograms)
        
    let totalWaterCalc : Double = mass.value * genderConstant
    var totalBodyWater : Measurement<UnitVolume> = Measurement(value: totalWaterCalc, unit: UnitVolume.liters)
        totalBodyWater = totalBodyWater.converted(to: UnitVolume.milliliters)
    
        let weightOfAlc = 23.36
        
        let alcPerWater = weightOfAlc / totalBodyWater.value
        
        let alcoholConcentration = alcPerWater * 0.806 * 100
        
        return alcoholConcentration
        
        
    }
    
   
}

struct Drink : Codable{
   // var drinkType : DrinkCategory
    var timeStarted : Date
    var timeFinished : Date
    var percent : Double
    var volume : Measurement<UnitVolume>
    var alcLevel : Double?
    
    init(timeConsumed: Date, percent: Double, volume: Measurement<UnitVolume>) {
        self.timeStarted = timeConsumed
        self.timeFinished = Date()
        self.percent = percent
        self.volume = volume
        self.alcLevel = calculateAlcLevel()
    }
    
    func calculateAlcLevel() -> Double {
        let consumed = volume.converted(to: .fluidOunces).value * percent
        
        let actualLevel = consumed * (currentUser.userBACProduction ?? 0.017)
        
        return actualLevel
         
        
    }
}
