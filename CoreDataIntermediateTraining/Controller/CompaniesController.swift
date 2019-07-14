//
//  CompaniesController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

private let tableCellId = "cellId"

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    func didAddCompany(_ company: Company) {
        
        companies.append(company)
        
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    var companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebbok", founded: Date()),
        Company(name: "Microsoft", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        setupTableViewStyle(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
    }
    
    func setupTableViewStyle(_ tableView: UITableView) {
        
        tableView.backgroundColor = UIColor.darkBlue
        
        //        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
    }
    
    @objc func handleAddCompany() {
        print("Adding Company...")
        
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
        
        setupCellStyle(cell)
        cell.textLabel?.text = companies[indexPath.row].name
        return cell
    }
    
    func setupCellStyle(_ cell: UITableViewCell) {
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    

}


