//
//  SettingsExpenseTypeViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/21/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class SettingsExpenseTypeViewController: UIViewController {
    
    var expenseType: ExpenseType!
    @IBOutlet weak var expenseTypeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if expenseType != nil {
            expenseTypeTF.text = expenseType.name
        }
        
    }
    
    @IBAction func updateExpenseTypesTable(_ sender: UIButton) {
        
        if let updateName = expenseTypeTF.text, updateName.count > 0 {
            
            if expenseType == nil {
                expenseType = ExpenseType(context: context)
            }
            
            expenseType.name = updateName
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            navigationController?.popViewController(animated: true)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Type the Expense type name to be saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }

}
