//
//  ExpensesManager.swift
//  ExpensesDiary
//
//  Created by Guido Roberto Carballo Guerrero on 5/10/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import CoreData

class ExpensesManager {
    
    static let shared = ExpensesManager()
    
    var expenses: [Expense] = []
    
    private init() {
        
    }
    
    func loadExpenses(with context: NSManagedObjectContext, startDate: Date, endDate: Date, type: ExpenseType?, comment: String?) {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        var predicateString = "day >= %@ AND day <= %@"
        var predicateArgs: [Any] = [startDate, endDate]
        
        if type != nil {
            predicateString += " AND (type == %@)"
            predicateArgs.append(type!)
        }
        
        if comment != nil {
            predicateString += " AND (comments CONTAINS[c] %@)"
            predicateArgs.append(comment!)
        }
        
        
        fetchRequest.predicate = NSPredicate(format: predicateString, argumentArray: predicateArgs)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            expenses = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteVehicle(index: Int, context: NSManagedObjectContext) {
        
        let expense = expenses[index]
        context.delete(expense)
        do {
            try context.save()
            expenses.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}
