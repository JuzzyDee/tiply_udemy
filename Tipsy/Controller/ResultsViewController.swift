//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Justin Davis on 16/7/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var calculatorBrain: CalculatorBrain?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Use the object method for calculating the split
        // to display to the end user
        let totalSplit = calculatorBrain!.calculateSplit()!
        //Update the label with a currency style format
        totalLabel.text = String(format: "$%.2f", totalSplit)
        // Use the object method built in to return the correct string
        // for the settings label
        settingsLabel.text = calculatorBrain?.getSettings()
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
