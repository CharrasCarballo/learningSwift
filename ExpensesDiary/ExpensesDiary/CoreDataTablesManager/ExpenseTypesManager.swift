//
//  ExpenseTypesManager.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/20/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import CoreData

class ExpenseTypesManager {
    
    static let shared = ExpenseTypesManager()
    var expenseTypes: [ExpenseType] = []
    
    private init() {
        
    }
    
    func loadExpenseTypes(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ExpenseType> = ExpenseType.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            expenseTypes = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteExpenseTypes(index: Int, context: NSManagedObjectContext) {
        
        let expenseType = expenseTypes[index]
        context.delete(expenseType)
        do {
            try context.save()
            expenseTypes.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
