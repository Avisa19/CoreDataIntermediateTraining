//
//  CreateCompanyController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

// Protocol Delegation
protocol CreateCompanyControllerDelegate {
    
    func didAddCompany(_ company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
        
    }
    
    @objc private func handleSave() {
    
        dismiss(animated: true) {
            
            guard let name = self.nameTextField.text else { return }
            
            let company = Company(name: name, founded: Date())
            
            self.delegate?.didAddCompany(company)
        }
        
    }
    
    private func setupUI() {
        
        
        let lightBlueBackgroundColor = UIView()
        lightBlueBackgroundColor.backgroundColor = .lightBlue
        lightBlueBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundColor)
        lightBlueBackgroundColor.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundColor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundColor.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundColor.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
