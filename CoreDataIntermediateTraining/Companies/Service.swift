//
//  Service.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 19/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompanyFromServer() {
        print("Attempting to download from server")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data", error)
                return
            }
            
            guard let data = data else { return }
          let jsonDecoder = JSONDecoder()
            do {
                
            let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
               let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                
                privateContext.parent = CoreDataManager.shared.PersistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsoncompany) in
                    print(jsoncompany.name)
                    
                     let company = Company(context: privateContext)
                    
                    company.name = jsoncompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                   let dateFormat = dateFormatter.date(from: jsoncompany.founded)
                    
                    company.founded = dateFormat
                    
                    do {
                        
                       try privateContext.save()
                      try  privateContext.parent?.save()
                       
                    } catch let saveErr {
                        print("Error saving data", saveErr)
                    }
                    
                    
                    jsoncompany.employees?.forEach({ (jsonEmployee) in
                        print("     \(jsonEmployee.name)")
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        employee.employeeInformation = employeeInformation
                        
                        employee.company = company
                    })
                })
                
            } catch let jsonErr {
                print("Error JSON Decoding..", jsonErr)
            }
            
        }.resume()
    }
    
}

struct JSONCompany: Decodable {
    
    let name: String
    let founded: String
    var employees: [jsonEmployee]?
    
}

struct jsonEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
