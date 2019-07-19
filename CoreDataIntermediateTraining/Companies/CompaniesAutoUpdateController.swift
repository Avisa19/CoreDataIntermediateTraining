//
//  CompaniesAutoUpdateController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 19/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {

    let cellId = "CelllId"
    
    lazy var fetchResultController: NSFetchedResultsController<Company> = {
            
        let context = CoreDataManager.shared.PersistentContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]
            
            let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
            
            frc.delegate = self
            
            do {
                try frc.performFetch()
            } catch let err {
                print(err)
            }
            
            return frc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        
//        fetchResultController.fetchedObjects?.forEach({ (company) in
//            print(company.name ?? "")
//        })
        
//        Service.shared.downloadCompanyFromServer()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        self.refreshControl = refreshControl
        
    }
    
    @objc private func handleRefresh() {
        Service.shared.downloadCompanyFromServer()
        self.refreshControl?.endRefreshing()
    }
    
    @objc private func handleDelete() {
        print("Delete...")
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
//        request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        
        let context = CoreDataManager.shared.PersistentContainer.viewContext
        
        let compantWitbB = try? context.fetch(request)
        
        compantWitbB?.forEach({ (company) in
            context.delete(company)
        })
        
        try? context.save()
    }
    
    @objc private func handleAdd() {
        print("Let's add a company name")
        
         let context = CoreDataManager.shared.PersistentContainer.viewContext
        let company = Company(context: context)
        
        company.name = "BMW"
        
        try? context.save()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = fetchResultController.sectionIndexTitles[section]
        label.textColor = UIColor.darkBlue
        label.backgroundColor = UIColor.lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        let company = fetchResultController.object(at: indexPath)
        
        cell.company = company
      
        return cell
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emloyeesListController = EmployeesController()
        emloyeesListController.company = fetchResultController.object(at: indexPath)
        navigationController?.pushViewController(emloyeesListController, animated: true)
        
    }
}
