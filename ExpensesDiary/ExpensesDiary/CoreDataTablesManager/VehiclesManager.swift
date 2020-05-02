//
//  VehiclesManager.swift
//  ExpensesDiary
//
//  Created by Guido R Carballo G on 4/23/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import CoreData

class VehiclesManager {
    
    static let shared = VehiclesManager()
    var vehicles: [Vehicle] = []
    
    private init() {
        
    }
    
    func loadVehicles(with context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            vehicles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteVehicle(index: Int, context: NSManagedObjectContext) {
        
        let vehicle = vehicles[index]
        context.delete(vehicle)
        do {
            try context.save()
            vehicles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
