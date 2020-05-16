//
//  NewExpenseViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/20/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit
import CoreLocation

class NewExpenseViewController: UIViewController {
    
    

    @IBOutlet weak var expenseTypeTF: UITextField!
    @IBOutlet weak var expenseValueTF: UITextField!
    @IBOutlet weak var expenseCommentsTV: UITextView!
    @IBOutlet weak var expenseDP: UIDatePicker!
    
    
    var expense: Expense!
    var gasExpense: GasExpense!
    
    var expenseTypesManager = ExpenseTypesManager.shared
    
    lazy var expenseTypePickerView: UIPickerView = {
        let expenseTypePickerView = UIPickerView()
        expenseTypePickerView.delegate = self
        expenseTypePickerView.dataSource = self
        expenseTypePickerView.backgroundColor = .white
        expenseTypePickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        return expenseTypePickerView
    }()
    
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestUserLocationAuthorization()
        prepareConsoleTextField()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenseTypesManager.loadExpenseTypes(with: context)
        
        //print("gasExpense: \(String(describing: gasExpense))")
        
    }
    
    func prepareConsoleTextField() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        
        expenseTypeTF.inputView = expenseTypePickerView
        expenseTypeTF.inputAccessoryView = toolbar
        
    }
    
    @objc func cancel() {
        
        expenseValueTF.becomeFirstResponder()
        
    }
    
    @objc func done() {
        
        expenseTypeTF.text = expenseTypesManager.expenseTypes[expenseTypePickerView.selectedRow(inComponent: 0)].name
        
        if expenseTypeTF.text == "Gas" {
            
            expenseValueTF.becomeFirstResponder()
            
            let gasExpenseVC = storyboard?.instantiateViewController(identifier: "GasExpenseViewController") as! GasExpenseViewController
            gasExpenseVC.modalPresentationStyle = .overCurrentContext
            gasExpenseVC.delegate = self
            present(gasExpenseVC, animated: true, completion: nil)
            
        }
        
        cancel()
        
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .denied, .restricted:
                    showMessage(type: .authorizationWarning, message: "If Location is authorize for this app at Settings/Privacy/Location Services your location will be saved for each expense.")
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.startUpdatingLocation()
                default:
                    break
            }
        } else {
            showMessage(type: .authorizationWarning, message: "Location services is disable. If you want to enable go to Settings and authorize this App to use your location.")
        }
    }
    
    
    
    @IBAction func saveExpense(_ sender: UIButton) {
        
        if expense == nil {
            expense = Expense(context: context)
        }
        
        var saveData = true
        
        if let type = expenseTypeTF.text, type.count > 0 {
            let expenseTypeSelected = expenseTypesManager.expenseTypes[expenseTypePickerView.selectedRow(inComponent: 0)]
            expense.type = expenseTypeSelected
        } else {
            showMessage(type: .noDataFound, message: "Need to select an expense type.")
            saveData = false
        }
        
        if let value = Float(expenseValueTF.text!) {
            expense.value = value
        } else {
            showMessage(type: .noDataFound, message: "Need to write how much was paid.")
            saveData = false
        }
        
        expense.day = expenseDP.date
        
        if let comments = expenseCommentsTV.text, comments.count > 0 {
            expense.comments = comments
        }
        
        if let location = locationManager.location {
            expense.longitude = String(describing: location.coordinate.longitude)
            expense.latitude = String(describing: location.coordinate.latitude)
        }
        
        if gasExpense != nil {
            expense.gasExpense = gasExpense
            print("Gas expense included")
        }
        
        if saveData {
            do {
                try context.save()
                expenseValueTF.text = ""
                expenseCommentsTV.text = ""
                expenseTypeTF.becomeFirstResponder()
                showMessage(type: .dataSaved, message: "Data saved successfully.", title: "Congrats!")
            } catch {
                showMessage(type: .errorSavingData, message: error.localizedDescription)
            }
        }
        
        
        /*if saveData {
            
            print("Type: \(expense.type?.name ?? "without type")")
            print("Value: \(expense.value)")
            print("Day: \(expense.day!)")
            print("Comments: \(expense.comments ?? "without comments")")
            print("Longitude: \(expense.longitude ?? "without long")")
            print("Latitude: \(expense.latitude ?? "without lat")")
            
        } else {
            print("Missing information")
        }*/
    }
}

extension NewExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseTypesManager.expenseTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let expenseTypes = expenseTypesManager.expenseTypes[row]
        return expenseTypes.name
    }
    
}

extension NewExpenseViewController: GasExpenseDelegate {
    func transferGasExpense(gasExpense: GasExpense) {
        self.gasExpense = gasExpense
        //print("gasExpense: \(String(describing: self.gasExpense))")
    }
}
