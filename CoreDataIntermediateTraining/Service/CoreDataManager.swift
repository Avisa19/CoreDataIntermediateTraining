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
    
    func fetchCompanies() -> [Company] {
        let context = PersistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>.init(entityName: "Company")
        do {
            
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Error fetching Company data: \(fetchErr)")
            return []
        }
    }
    
    func createEmployee(employeeName: String, birthday: Date, employeeType: String, company: Company) -> (Employee?, Error?) {
        
        let context = PersistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.setValue(employeeName, forKey: "name")
        employee.company = company
        employee.type = employeeType
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.birthday = birthday
        
        
//        employeeInformation.taxId = "456"
//        employeeInformation.setValue("234", forKey: "taxId")
        
       employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Error creating employee:", err)
            return (nil, err)
        }
    }
    
}
