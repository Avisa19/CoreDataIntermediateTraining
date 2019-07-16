//
//  CoreDataManager.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // it will live as long as you app lives and it's properties.
    
    let PersistentContainer: NSPersistentContainer  = {
        
        //Initialazation of our Core Data
        let container = NSPersistentContainer(name: "CoreDataIntermediateTraining")
        container.loadPersistentStores { (persistDescription, err) in
            if let err = err {
                fatalError("Laoding error is failed: \(err)")
            }
        }
        
        return container
        
    }()
    
}
