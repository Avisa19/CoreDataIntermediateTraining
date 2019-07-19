//
//  CompaniesController + CreateCompanyDelegate.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 17/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didEditCompany(_ company: Company) {
        // update my tableview somehow
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    
    func didAddCompany(_ company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    // specify your extension methods here....
    
}
