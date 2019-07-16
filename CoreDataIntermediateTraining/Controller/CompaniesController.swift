//
//  CompaniesController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import CoreData

private let tableCellId = "cellId"

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    func didAddCompany(_ company: Company) {
        
        companies.append(company)
        
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func didEditCompany(_ company: Company) {
        
        let row = companies.firstIndex(of: company)
        
        let indexPath = IndexPath(row: row!, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    
    var companies = [Company]()
    
    private func fetchCompanies() {
 
        let context = CoreDataManager.shared.PersistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>.init(entityName: "Company")
        do {
            
             let companies = try context.fetch(fetchRequest)
            
//            companies.forEach { (company) in
//                print(company.name ?? "")
//            }
            
            self.companies = companies
            
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Error fetching Company data: \(fetchErr)")
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            
            let company = self.companies[indexPath.row]
//            print("You are deleting:", company.name ?? "")
            
            // remove the company from our tableView
            self.companies.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // remove the company from our CoreData
            let context = CoreDataManager.shared.PersistentContainer.viewContext
            context.delete(company)
            do {
                
                try context.save()
                
            } catch let saveErr {
                print("Failed to Delete Company name:", saveErr)
            }
            
        }
        
        deleteAction.backgroundColor = .lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        
        print("Edit Selecting Company...")
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchCompanies()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        setupTableViewStyle(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath)
        
        let company = companies[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "select_photo_empty")
        
        if let imageData = company.imageData {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image
        }
        
        if let name = company.name, let dateFounded = company.founded {
            
//            let locale = Locale(identifier: "EN")
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMM dd, YYYY"
            
            let dateFoundedString = dateFormatter.string(from: dateFounded)
            
            let dateString = "\(name) - Founded: \(dateFoundedString)"
            
            cell.textLabel?.text = dateString
            
        
        
        } else {
            cell.textLabel?.text = company.name
        }
        
        setupCellStyle(cell)
 
        return cell
    }
    
    
   private func setupCellStyle(_ cell: UITableViewCell) {
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    

}


