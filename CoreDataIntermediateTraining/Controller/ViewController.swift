//
//  ViewController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 14/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()
        
    }
    
    @objc func handleAddCompany() {
        
    }

    func setupNavigationStyle() {
        
        let lightRed = UIColor.rgb(red: 247, green: 66, blue: 82)
        
        navigationController?.navigationBar.barTintColor = lightRed
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

