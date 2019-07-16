//
//  CreateCompanyController.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 15/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import CoreData



// Protocol Delegation
protocol CreateCompanyControllerDelegate {
    
    func didAddCompany(_ company: Company)
    func didEditCompany(_ company: Company)
    
}

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    
    var company: Company? {
 
        didSet {
            nameTextField.text = company?.name
            guard let date = company?.founded, let imageString = company?.imageView else { return }
            datePicker.date = date
            
            companyImageView.image = UIImage(named: imageString)
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let image = UIImage(named: "select_photo_empty")
       let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true // remember to do this, otherwise your image view by default is not interactive.
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        print("We try to select photo...")
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.isEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            companyImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
        companyImageView.image = originalImage
    }
    
        dismiss(animated: true, completion: nil)
        
    }
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ternary operation
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
        
    }
    
    @objc private func handleSave() {
        
        if company == nil {
            
            createCompany()
            
        } else {
            
            saveChangesCompany()
        }
    }
    
    private func saveChangesCompany() {
        
        let context = CoreDataManager.shared.PersistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        
        do {
            
            try context.save()
            
            dismiss(animated: true) {
                guard let company = self.company else { return }
                self.delegate?.didEditCompany(company)
                
            }
            
        } catch let saveErr {
            
            print("Faild to save editing Company:", saveErr)
        }
    }
    
    private func createCompany() {
        let context = CoreDataManager.shared.PersistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        // Perform the save
        
        do {
            
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company as! Company)
            }
            
        } catch let saveErr {
            
            print("Failed to save Comapny name: \(saveErr)")
            
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
        lightBlueBackgroundColor.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        // setup the DatePicker
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundColor.bottomAnchor).isActive = true
        
        
        
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
