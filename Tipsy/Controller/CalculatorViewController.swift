//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
   
    // Add relevent Interface Builder links
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var invalidNumberLabel: UILabel!
    @IBOutlet weak var customTipField: UITextField!
    @IBOutlet weak var invalidTipLabel: UILabel!
    
    // This object will do the heavy lifting
    var calculatorBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidNumberLabel.text = "Error: Please enter a valid bill total"
        //Looks for single or multiple taps.
        // This dismisses the keyboard if user
        // taps outside the bounds of the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Add the default values to the calc brain
        calculatorBrain.tipPercent = 0.10
        calculatorBrain.splitCount = Double(splitNumberLabel.text!)
    }
    
    @IBAction func billTextFieldEdited(_ sender: UITextField) {
        
        // As the user types, validate their entry
        if calculatorBrain.updateBill(billText: sender.text ?? "") {
            // It's a valid number. Format and store
            sender.textColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
            invalidNumberLabel.isHidden = true
        } else {
            if sender.text! == "" {
                // The field is empty, so empty the value
                calculatorBrain.billAmount = nil
            } else {
                // Not empty and can't be converted to a Float, so alert the user
                sender.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                invalidNumberLabel.isHidden = false
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    // Tip section
    // First handle the default presets
    @IBAction func tipChanged(_ sender: UIButton) {
        // Each time a tip button is pushed, deselect all 3 buttons
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
        // And select the sender for this event
        sender.isSelected = true
        let tipFloat: Float = Float(sender.currentTitle!.replacingOccurrences(of: "%", with: ""))!/100
        calculatorBrain.tipPercent = tipFloat
    }
    // Now handling the custom pct field
    @IBAction func pcentTextFieldUpdated(_ sender: UITextField) {
        
        if calculatorBrain.validateFloat(input: sender.text) {
            // It's a valid number, so update the tip
            calculatorBrain.tipPercent = Float(sender.text!)! / 100
            // Deselect all the tip buttons
            zeroPctButton.isSelected = false
            tenPctButton.isSelected = false
            twentyPctButton.isSelected = false
            // Hide any error that might be showing
            invalidTipLabel.isHidden = true
            sender.textColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
        } else if sender.text != "" {
            // Has a value, but not valid number
            sender.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            invalidTipLabel.isHidden = false
        } else {
            // The only option left is not a number and blank
            // Hide any error
            invalidTipLabel.isHidden = true
            sender.textColor = #colorLiteral(red: 0, green: 0.6901960784, blue: 0.4196078431, alpha: 1)
            // If none of the buttons are selected (Previously had a custom tip)
            // select at least one
            if !(zeroPctButton.isSelected || tenPctButton.isSelected || twentyPctButton.isSelected) {
                tenPctButton.isSelected = true
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // Update the label to reflect the stepper position
        calculatorBrain.splitCount = sender.value
        // WHile we're at it, update the brain too
        splitNumberLabel.text = String(format: "%.0f", sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        // Send values to the bill calculator
        if calculatorBrain.validateBill() {
            // Load the result view
            self.performSegue(withIdentifier: "resultsSegue", sender: self)
        } else {
            // For debugging, the user tried to press calculate with invalid or blank values
            // Ideally they should see an error label explaining why calculate is failing to
            // show results
            invalidNumberLabel.isHidden = false
            print("Can not calculate bill due to missing value")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the entire calculatorBrain object to the new view controller.
        if segue.identifier == "resultsSegue" {
            let nextVC = segue.destination as! ResultsViewController
            nextVC.calculatorBrain = calculatorBrain
        }
    }
}

