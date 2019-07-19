//
//  UIViewConroller + Helper.swift
//  CoreDataIntermediateTraining
//
//  Created by Avisa on 17/7/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // UIViewController are the main View for all collection and tableView.
    
    func setupPlusButtonInNavBar(_ selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc private func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundColor(_ height: CGFloat) -> UIView {
        let lightBlueBackgroundColor = UIView()
        lightBlueBackgroundColor.backgroundColor = .lightBlue
        lightBlueBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightBlueBackgroundColor)
        lightBlueBackgroundColor.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundColor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundColor.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundColor.heightAnchor.constraint(equalToConstant: height).isActive = true
        
          return lightBlueBackgroundColor
    }
}
