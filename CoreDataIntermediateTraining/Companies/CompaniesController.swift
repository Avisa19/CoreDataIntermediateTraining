//
//  CompaniesController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import CoreData



class CompaniesController: UITableViewController {
    
     let tableCellId = "cellId"
    
    var companies = [Company]()
    
    @objc private func doWork() {
        print("do working here...")
        
        CoreDataManager.shared.PersistentContainer.performBackgroundTask { (backgroundContext) in
            
            (0...5).forEach({ (value) in
                let name = String(value)
                let company = Company(context: backgroundContext)
                company.name = name
            })
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save,", err)
            }
            
        }
    }
    
    @objc func doUpdates() {
        CoreDataManager.shared.PersistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
            let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
            } catch let err {
                print("Err fetching", err)
            }
            
            do {
                try backgroundContext.save()
                // Update UI
                DispatchQueue.main.async {
                    CoreDataManager.shared.PersistentContainer.viewContext.reset()
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let saveErr {
                print("Error saving data", saveErr)
            }
        }
    }
    
    @objc private func doNestedUpdates() {
        print("trying to run nested updates now...")
        
        DispatchQueue.global(qos: .background).async {
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.PersistentContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    
                    // after save succeeds
                    
                    DispatchQueue.main.async {
                        
                        do {
                            let context = CoreDataManager.shared.PersistentContainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                            
                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }
                        
                    }
                    
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
                
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       self.companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        setupTableViewStyle(tableView)
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: tableCellId)
        
        setupPlusButtonInNavBar(#selector(handleAddCompany))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            
            UIBarButtonItem(title: "Do NestedUpdates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
    }
    
    @objc private func handleReset() {
        
        print("Attempting to delete all coreData object")
        let context = CoreDataManager.shared.PersistentContainer.viewContext
        
//        companies.forEach { (company) in
//            context.delete(company)
//        }
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            
            try context.execute(batchDeleteRequest)
//            companies.removeAll()
//            tableView.reloadData()
            // because we want to see nice Animation while in deleting
            var removedIndexPath = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                removedIndexPath.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: removedIndexPath, with: .left)
            
        } catch let errDel {
            print("Error deleting objects:", errDel)
        }
    }
    
   private func setupTableViewStyle(_ tableView: UITableView) {
        
        tableView.backgroundColor = UIColor.darkBlue
        
        //        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
    }
    
    @objc func handleAddCompany() {
      
        let createCompanyController = CreateCompanyController()
       
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
}


