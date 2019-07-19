//
//  EmployeesController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 17/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import CoreData

// Let's create a UILable subclass for custom text drawing
class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    // when we dismiss creation employee it will run
    func didAddEmployee(_ employee: Employee) {

        guard let section = employeesType.firstIndex(of: employee.type!) else { return }
        
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)

    }
    
    
    var company: Company?
    
//    var employees = [Employee]()
    
   let cellId = "celllllId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
        
    }
    
    var allEmployees = [[Employee]]()
    
    var employeesType = [
        EmployeeType.Intern.rawValue,
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    private func fetchEmployee() {
        
        //everytime we fetch , we should fresh new data to Array
        //everytime you add new Item, you should refresh your array
        allEmployees = []
        
        // It fetch through company fetch request
        guard let employeesCompany = company?.employees?.allObjects as? [Employee] else { return }
        
        // let's filter employees for Executive
        // let's use my array and use filter instead
        
        employeesType.forEach { (employeeType) in
            
            allEmployees.append(employeesCompany.filter{ $0.type == employeeType })
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        tableView.separatorStyle = .none
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(#selector(handleAdd))
        
         fetchEmployee()
    }
    
    @objc private func handleAdd() {
        print("Attempting to Add employee...")
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = self.company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
     
        label.text = employeesType[section]
       
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
       let employee = allEmployees[indexPath.section][indexPath.row]

        cell.textLabel?.text = employee.name
        
        if let birthdayDate = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM ,dd yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")  \(dateFormatter.string(from: birthdayDate))"
        }
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
}
