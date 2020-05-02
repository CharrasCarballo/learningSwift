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
    
    enum MapMessageType {
        case routeError
        case authorizationWarning
    }

    @IBOutlet weak var expenseTypeTF: UITextField!
    @IBOutlet weak var expenseValueTF: UITextField!
    @IBOutlet weak var expenseCommentsTV: UITextView!
    @IBOutlet weak var expenseDP: UIDatePicker!
    @IBOutlet weak var carButtonItem: UIBarButtonItem!
    
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
        
        carButtonItem.image = UIImage(systemName: "")
        carButtonItem.isEnabled = false
        
        expenseTypesManager.loadExpenseTypes(with: context)
        
        print("gasExpense: \(String(describing: gasExpense))")
        
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
        
        expenseTypeTF.resignFirstResponder()
        
    }
    
    @objc func done() {
        
        expenseTypeTF.text = expenseTypesManager.expenseTypes[expenseTypePickerView.selectedRow(inComponent: 0)].name
        
        if expenseTypeTF.text == "Gas" {
            carButtonItem.image = UIImage(systemName: "car")
            carButtonItem.isEnabled = true
        } else {
            carButtonItem.image = UIImage(systemName: "")
            carButtonItem.isEnabled = false
        }
        
        cancel()
        
    }
    
    func requestUserLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .denied, .restricted:
                    showMessage(type: .authorizationWarning)
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.startUpdatingLocation()
                default:
                    break
            }
        } else {
            showMessage(type: .authorizationWarning)
        }
    }
    
    func showMessage(type: MapMessageType) {
        
        let title = type == .authorizationWarning ? "FYI" : "Error"
        let message = type == .authorizationWarning ? "If Location is authorize for this app at Settings/Privacy/Location Services your location will be saved for each expense." : "The Location is not available."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if type == .authorizationWarning {
            let confirmAction = UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
                
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
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
            let alert = UIAlertController(title: "Error", message: "Need to select an expense type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            saveData = false
        }
        
        if let value = Float(expenseValueTF.text!) {
            expense.value = value
        } else {
            let alert = UIAlertController(title: "Error", message: "Need write a value.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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
        
        if saveData {
            
            print("Type: \(expense.type?.name ?? "without type")")
            print("Value: \(expense.value)")
            print("Day: \(expense.day!)")
            print("Comments: \(expense.comments ?? "without comments")")
            print("Longitude: \(expense.longitude ?? "without long")")
            print("Latitude: \(expense.latitude ?? "without lat")")
            
        } else {
            print("Missing information")
        }
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
    }
}
