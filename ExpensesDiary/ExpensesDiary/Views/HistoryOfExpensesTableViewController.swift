//
//  HistoryOfExpensesTableViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/20/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class HistoryOfExpensesTableViewController: UITableViewController {
    
    @IBOutlet weak var datesLB: UILabel!
    
    var initialDate: Date?
    var finalDate: Date?
    var expenseType: ExpenseType?
    var comments: String?
    
    let dateFormatter = DateFormatter()
    
    var expensesManager = ExpensesManager.shared
    //var expenseTypesManager = ExpenseTypesManager.shared
    
    var expensesValues: [ExpenseType:Float] = [:]
    var expensesNames: [ExpenseType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "MMMM d, YYYY"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var days: [Date]
        expensesValues = [:]
        expensesNames = []
        
        if initialDate == nil {
            days = returnCurrentMonthInitialFinalDate()
            initialDate = days[0]
            finalDate = days[1]
        } else {
            days = [initialDate!, finalDate!]
        }
        
        datesLB.text = dateFormatter.string(from: days[0]) + " - " +  dateFormatter.string(from: days[1])
        
        //print(days)
        
        expensesManager.loadExpenses(with: context, startDate: days[0], endDate: days[1], type: expenseType, comment: comments)
        //expenseTypesManager.loadExpenseTypes(with: context)
        
        print(expensesManager.expenses)
        
        for expense in expensesManager.expenses {
            let name = expense.type!
            if expensesValues[name] == nil {
                expensesValues[name] = expense.value
            } else {
                expensesValues[name] = expensesValues[name]! + expense.value
            }
        }
        
        print("expensesValues")
        print(expensesValues)
        
        for key in expensesValues.keys {
            expensesNames.append(key)
        }
        
        print("expensesNames")
        print(expensesNames)
        
        tableView.reloadData()
    }
    
    func setData(initialDate:Date, finalDate: Date, expenseType: ExpenseType?, comments: String?) {
        self.initialDate = initialDate
        self.finalDate = finalDate
        self.expenseType = expenseType
        self.comments = comments
    }
    
    func returnCurrentMonthInitialFinalDate() -> [Date] {
        
        let currentDay = Date()

        let calendar = Calendar(identifier: .gregorian)
        let componentsD1 = calendar.dateComponents([.year, .month], from: currentDay)

        let d1 = calendar.date(from: componentsD1)!
        
        var componentsD2 = DateComponents()
        componentsD2.month = 1
        componentsD2.day = -1

        let d2 = Calendar(identifier: .gregorian).date(byAdding: componentsD2, to: d1)!
        
        return [d1, d2]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFilteringVC" {
            let vc = segue.destination as! HistoryFilterSettingsViewController
            vc.historyOfExpenses = self
        } else {
            let vc = segue.destination as! HistoryForSpecificTypeTableViewController
            let selectedType = expensesNames[tableView.indexPathForSelectedRow?.row ?? 0]
            vc.setData(initialDate: self.initialDate!, finalDate: self.finalDate!, expenseType: selectedType, comments: self.comments)
        }
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*print("\nStoryboard ID: \(segue.destination.restorationIdentifier ?? "unknown restorationIdentifier")")
        print("Segue: \(segue.identifier ?? "without id")")*/
        
        if segue.destination.restorationIdentifier == "expenseType" && segue.identifier != "newExpenseType" {
            let vc = segue.destination as! SettingsExpenseTypeViewController
            vc.expenseType = expenseTypesManager.expenseTypes[expensesTypesTableView.indexPathForSelectedRow?.row ?? 0]
        } else if segue.destination.restorationIdentifier == "vehicle" && segue.identifier != "newVehicle" {
            let vc = segue.destination as! SettingsVehicleViewController
            vc.vehicle = vehiclesManager.vehicles[vehiclesTableView.indexPathForSelectedRow?.row ?? 0]
        }
        
    }*/

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("expensesNames.count")
        print(expensesNames.count)
        if expensesNames.count == 0 {
            return 1
        } else {
            return expensesNames.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        if expensesNames.count == 0 {
            cell.textLabel?.text = "No expenses found for this period"
        } else {
            let key = expensesNames[indexPath.row]
            let value = expensesValues[key]!
            print("expensesNames: \(expensesNames)")
            print("key")
            print(key)
            print("value")
            print(expensesValues[key]!)

            cell.textLabel?.text = String(format: "%@: $%.2f", key.name!, value)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
