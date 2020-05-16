//
//  HistoryForSpecificTypeTableViewController.swift
//  ExpensesDiary
//
//  Created by Guido Roberto Carballo Guerrero on 5/15/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class HistoryForSpecificTypeTableViewController: HistoryOfExpensesTableViewController {
    
    @IBOutlet weak var titleForNavigationBar: UINavigationItem!
    
    var daysOfExpenses: [String:[Expense]] = [:]
    var days: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let title = expenseType?.name
        
        titleForNavigationBar.title = "\(title!) expenses"
        
        if let receivedExpenseType = self.expenseType?.name {
            print(receivedExpenseType)
        } else {
            print("No expenseType received")
        }
        
        for expense in expensesManager.expenses {
            let day = dateFormatter.string(from:expense.day!)
            if daysOfExpenses[day] == nil {
                daysOfExpenses[day] = [expense]
                days.append(day)
            } else {
                daysOfExpenses[day]?.append(expense)
            }
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return daysOfExpenses.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days[section]
    }
    
    /*override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var daysString: [String] = []
        for day in daysOfExpenses.keys {
            daysString.append(dateFormatter.string(from: day))
        }
        
        return daysString
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return daysOfExpenses[days[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryforSpecificTypeTableViewCell

        let section = days[indexPath.section]
        let sectionData = daysOfExpenses[section]
        let cellData = sectionData![indexPath.row]
        
        var comments: String!
        
        if cellData.comments == nil {
            comments = "Expense without comments"
        } else {
            comments = cellData.comments
        }
        
        let value = cellData.value
        
        cell.prepare(with: comments, and: value)

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
