//
//  SettingsViewController.swift
//  FightingRounds
//
//  Created by Guido R Carballo G on 9/30/19.
//  Copyright © 2019 Guido R Carballo G. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var roundsPickerView: UIPickerView!
    @IBOutlet weak var breakPickerView: UIPickerView!
    @IBOutlet weak var numberOfFightersTF: UITextField!
    
    let times = Array(0...59)
    
    let roundTimerSettings = RoundTimerSettings.shared
    let fightersInfo = MatchingPairs.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        fightersInfo.setNumberOf(Int(numberOfFightersTF.text ?? "2")!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func formatView() {
        
        roundsPickerView.selectRow(roundTimerSettings.roundMinutes, inComponent: 0, animated: true)
        roundsPickerView.selectRow(roundTimerSettings.roundSeconds, inComponent: 2, animated: true)
        
        breakPickerView.selectRow(roundTimerSettings.breakMin, inComponent: 0, animated: true)
        breakPickerView.selectRow(roundTimerSettings.breakSec, inComponent: 2, animated: true)
        
        numberOfFightersTF.text = String(fightersInfo.getNumberOffighters())
    }

    /*@IBAction func returnToClockVC(_ sender: UIButton) {
        
        roundTimerSettings.numberOfFighters = Int(numberOfFightersTF.text ?? "2")!
        
        let notificationName = Notification.Name("returningToClockView")
        NotificationCenter.default.post(name: notificationName, object: nil)
        self.dismiss(animated: true, completion: nil)
    }*/
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 4
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0, 2:
            return times.count
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        switch component {
        case 0, 2:
            pickerLabel.text = String(times[row])
            pickerLabel.textAlignment = .center
            //pickerLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        case 1:
            pickerLabel.text = "min"
            pickerLabel.textAlignment = .left
            //pickerLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        default:
            pickerLabel.text = "sec"
            pickerLabel.textAlignment = .left
            //pickerLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == roundsPickerView {
            
            if component == 0 {
                roundTimerSettings.roundMinutes = times[row]
                //print(roundTimerSettings.roundMinutes)
            } else if component == 2 {
                roundTimerSettings.roundSeconds = times[row]
                //print(roundTimerSettings.roundSeconds)
            }
            
        } else if pickerView == breakPickerView {
            
            if component == 0 {
                roundTimerSettings.breakMin = times[row]
                //print(roundTimerSettings.breakMin)
            } else if component == 2 {
                roundTimerSettings.breakSec = times[row]
                //print(roundTimerSettings.breakSec)
            }
            
        }
    }

}
