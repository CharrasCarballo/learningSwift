//
//  GasExpenseViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/25/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

protocol GasExpenseDelegate: class {
    func transferGasExpense(gasExpense: GasExpense)
}

class GasExpenseViewController: UIViewController {
    
    @IBOutlet weak var mileageTF: UITextField!
    @IBOutlet weak var gallonsTF: UITextField!
    @IBOutlet weak var gasPriceTF: UITextField!
    
    var gasExpense: GasExpense!
    
    var vehiclesManager = VehiclesManager.shared
    
    weak var delegate: GasExpenseDelegate?
    
    lazy var vehiclesPickerView: UIPickerView = {
        let vehiclesPickerView = UIPickerView()
        vehiclesPickerView.delegate = self
        vehiclesPickerView.dataSource = self
        vehiclesPickerView.backgroundColor = .white
        vehiclesPickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return vehiclesPickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vehiclesManager.loadVehicles(with: context)
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
    
    @IBAction func saveGasExpense(_ sender: UIButton) {
        
        if gasExpense == nil {
            gasExpense = GasExpense(context: context)
        }
        
        if let mileage = checkTF(textField: mileageTF, errorMes: nil) {
            gasExpense.currentMileage = Int32(mileage) ?? 0
        }
        
        if let gallons = checkTF(textField: gallonsTF, errorMes: nil) {
            gasExpense.gallons = Float(gallons) ?? 0
        }
        
        if let gasPrice = checkTF(textField: gasPriceTF, errorMes: nil) {
            gasExpense.gasPrice = Float(gasPrice) ?? 0
        }
        
        gasExpense.vehicle = vehiclesManager.vehicles[vehiclesPickerView.selectedRow(inComponent: 0)]
        
        delegate?.transferGasExpense(gasExpense: gasExpense)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*print("\nStoryboard ID: \(segue.destination.restorationIdentifier ?? "unknown restorationIdentifier")")
        print("Segue: \(segue.identifier ?? "without id")")*/
        
        print(segue.destination.restorationIdentifier ?? "no identifier")
        
    }

}

extension GasExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehiclesManager.vehicles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let vehicle = vehiclesManager.vehicles[row]
        return vehicle.name
    }
    
}
