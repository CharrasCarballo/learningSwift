//
//  SettingsViewController.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/21/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var expensesTypesTableView: UITableView!
    @IBOutlet weak var vehiclesTableView: UITableView!
    @IBOutlet weak var emptyTableExpenseTypesView: UIView!
    @IBOutlet weak var emptyTableVehiclesView: UIView!
    
    var expenseTypesManager = ExpenseTypesManager.shared
    var vehiclesManager = VehiclesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        expenseTypesManager.loadExpenseTypes(with: context)
        vehiclesManager.loadVehicles(with: context)
        expensesTypesTableView.reloadData()
        vehiclesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*print("\nStoryboard ID: \(segue.destination.restorationIdentifier ?? "unknown restorationIdentifier")")
        print("Segue: \(segue.identifier ?? "without id")")*/
        
        if segue.destination.restorationIdentifier == "expenseType" && segue.identifier != "newExpenseType" {
            let vc = segue.destination as! SettingsExpenseTypeViewController
            vc.expenseType = expenseTypesManager.expenseTypes[expensesTypesTableView.indexPathForSelectedRow?.row ?? 0]
        } else if segue.destination.restorationIdentifier == "vehicle" && segue.identifier != "newVehicle" {
            let vc = segue.destination as! SettingsVehicleViewController
            vc.vehicle = vehiclesManager.vehicles[vehiclesTableView.indexPathForSelectedRow?.row ?? 0]
        }
        
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == expensesTypesTableView {
            if expenseTypesManager.expenseTypes.count > 0 {
                emptyTableExpenseTypesView.isHidden = true
            } else {
                emptyTableExpenseTypesView.isHidden = false
            }
            return expenseTypesManager.expenseTypes.count
        } else if tableView == vehiclesTableView {
            if vehiclesManager.vehicles.count > 0 {
                emptyTableVehiclesView.isHidden = true
            } else {
                emptyTableVehiclesView.isHidden = false
            }
            return vehiclesManager.vehicles.count
        } else {
            print("TableView not recognized in rows in section")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == expensesTypesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellExpenseTypes", for: indexPath)
            cell.textLabel?.text = expenseTypesManager.expenseTypes[indexPath.row].name
            return cell
        } else if tableView == vehiclesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellVehicles", for: indexPath)
            cell.textLabel?.text = vehiclesManager.vehicles[indexPath.row].name
            return cell
        } else {
            print("TableView not recognized in cell at row")
            return tableView.dequeueReusableCell(withIdentifier: "cellVehicles", for: indexPath)
        }
    }
    
    
}
