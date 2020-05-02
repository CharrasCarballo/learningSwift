//
//  SettingsVehicleViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/21/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class SettingsVehicleViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var plateTF: UITextField!
    @IBOutlet weak var vinTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    
    var vehicle : Vehicle!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if vehicle != nil {
            nameTF.text = vehicle.name
            
            if let model = vehicle.model {
                modelTF.text = model
            }
            
            if let plate = vehicle.plate {
                plateTF.text = plate
            }
            
            if let vin = vehicle.vin {
                vinTF.text = vin
            }
            
            if let titleNum = vehicle.titleNumber {
                titleTF.text = titleNum
            }
        }
        
    }
    
    func checkTF(textField: UITextField, errorMes: String?) -> String? {
        
        if let tfString = textField.text, tfString.count > 0 {
            return tfString
        } else if errorMes != nil {
            let alert = UIAlertController(title: "Error", message: errorMes, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        return nil
    }
    
    @IBAction func saveVehicle(_ sender: UIButton) {
        
        if vehicle == nil {
            vehicle = Vehicle(context: context)
        }
        
        if let name = checkTF(textField: nameTF, errorMes: "You need to select a name for this vehicle.") {
            
            vehicle.name = name
            
            if let model = checkTF(textField: modelTF, errorMes: nil) {
                vehicle.model = model
            }
            
            if let plate = checkTF(textField: plateTF, errorMes: nil) {
                vehicle.plate = plate
            }
            
            if let vin = checkTF(textField: vinTF, errorMes: nil) {
                vehicle.vin = vin
            }
            
            if let titleNum = checkTF(textField: titleTF, errorMes: nil) {
                vehicle.titleNumber = titleNum
            }
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            navigationController?.popViewController(animated: true)
            
        }
    }

}
