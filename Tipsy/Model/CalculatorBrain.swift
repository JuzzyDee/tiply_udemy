//
//  CalculatorBrain.swift
//  Tipsy
//
//  Created by Justin Davis on 16/7/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    // The pieces needed to calculate the end result
    var billAmount: Float?
    var tipPercent: Float?
    var splitCount: Double?
    // Hold the final split
    var splitAmount: Float?


    mutating func updateBill(billText: String) -> Bool {
        // Attempts to update billAmount with float conversion
        // returns true on success or false on failure (Due to invalid number)
        guard let checkNum = Float(billText) else {
            // Returns false to indicate value has NOT been updated
            return false
        }
        // Returns true after value updated
        billAmount = checkNum
        return true
    }
    
    func validateBill() -> Bool {
        // See if any of the three key peices of data return "nil"
        // Prevent run time errors by calling this before attempting
        // the calculation. If true we can force unpack without fear of a
        // crash
        let billOK: Bool = self.billAmount != nil
        let tipOK: Bool = self.tipPercent != nil
        let splitOK: Bool = self.splitCount != nil
        
        // Combine with and to make sure all three are present
        if billOK && tipOK && splitOK {
            // Returns true if data set is ready to calculate
            return true
        }
        // Returns false where data is incomplete
        return false
    }
    
    mutating func calculateSplit() -> Float? {
        // Do a double check to prevent runtime errors
        if validateBill() {
            // All numbers are valied, so calculate the split amount including tip
            self.splitAmount = (billAmount! * (1 + tipPercent!)) / Float(splitCount!)
            return splitAmount
        }
        // Attempted to calculate when incomplete, return nil for optional value
        return nil
    }
    
    func getSettings() -> String? {
        // The results page shows a plain text string for the "settings"
        // use the data collected to generate the contents of this label
        let peopleString = "Split between " + String(format: "%.0f", self.splitCount!) + " people"
        let tipString = ", with a " + String(format: "%.0f", tipPercent!*100) + "% tip."
        let settingsString = peopleString + tipString
        return settingsString
    }
    
    func validateFloat(input: Any?) -> Bool {
        // A non dependant validation method allowing confirmation
        // that any value can be converted to a float before attempting
        // the conversion. This is also to prevent runtime errors
        guard let _ = Float(input as! String) else {
            return false
        }
        // Start with the default assumption that the value can not be cast as a float
        return true
    }
    
}
