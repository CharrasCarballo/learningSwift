//
//  HistoryFilterSettingsViewController.swift
//  ExpensesDiary
//
//  Created by Guido Roberto Carballo Guerrero on 5/10/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class HistoryFilterSettingsViewController: UIViewController {

    @IBOutlet weak var initialDateDP: UIDatePicker!
    @IBOutlet weak var finalDateDP: UIDatePicker!
    @IBOutlet weak var expenseTypePickerView: UIPickerView!
    @IBOutlet weak var commentsTF: UITextField!
    
    var historyOfExpenses: HistoryOfExpensesTableViewController?
    
    var expenseTypesManager = ExpenseTypesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expenseTypesManager.loadExpenseTypes(with: context)
        
        //print("gasExpense: \(String(describing: gasExpense))")
        
    }
    
    @IBAction func displayHistory(_ sender: UIButton) {
        
        let rowSelected = expenseTypePickerView.selectedRow(inComponent: 0)
        
        var expenseType: ExpenseType?
        
        if rowSelected == 0 {
            expenseType = nil
        } else {
            expenseType = expenseTypesManager.expenseTypes[rowSelected-1]
        }
        
        historyOfExpenses?.setData(initialDate: initialDateDP.date, finalDate: finalDateDP.date, expenseType: expenseType, comments: checkTF(textField: commentsTF, errorMes: nil))
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension HistoryFilterSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return expenseTypesManager.expenseTypes.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "All"
        } else {
            let expenseTypes = expenseTypesManager.expenseTypes[row-1]
            return expenseTypes.name
        }
    }
    
}
