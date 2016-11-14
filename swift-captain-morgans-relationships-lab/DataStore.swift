//
//  DataStore.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Enrique Torrendell on 11/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    var pirates: [Pirate] = []
    var ships: [Ship] = []
    var engines: [Engine] = []
    
    static let shareInstance = DataStore()
    
    private init() {}
    
    lazy var persistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Pirates")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unsolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        let context = persistantContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() {
        let context = persistantContainer.viewContext
        let pirateRequest = NSFetchRequest<Pirate>(entityName: "Pirate")
                let shipRequest = NSFetchRequest<Ship>(entityName: "Ship")
                let engineRequest = NSFetchRequest<Engine>(entityName: "Engine")
        
        do {
            pirates = try context.fetch(pirateRequest)
                        ships = try context.fetch(shipRequest)
                        engines = try context.fetch(engineRequest)
            
        } catch let error {
            print("Error fetching data: \(error)")
        }
        
    }
    
}

extension DataStore {
    
    func generateTestData() {
        
        let context = persistantContainer.viewContext
        
        //generating Pirates
        for i in 1...20 {
            
            let pirate = Pirate(context: context)
            pirate.name = "Pirate #\(i)"
            
            //generating ships
            for i in 1...10 {
                
                let ship = Ship(context: context)
                ship.name = "Ship n#\(i) from \(pirate.name!)"
                pirate.addToShips(ship)
                
                
                //generating engine
                let engine = Engine(context: context)
                let typeOfEngines = ["sail", "gas", "oars", "nuclear"]
                engine.engineType = typeOfEngines[Int(arc4random_uniform(UInt32(typeOfEngines.count)))]
                ship.engines = engine
                
                
            }
        }
        
        saveContext()
        fetchData()
        
    }
    
}
