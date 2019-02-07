//
//  UIView+activityIndicator.swift
//  iSigma
//
//  Created by Alex Delin on 07/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIView {
    func addActivityIndicator(view: UIView) -> UIView {
        
        self.frame = view.bounds
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        var imagesArray = [UIImage(named: "activity\(0)")!]
        for i in 1..<30 {
            imagesArray.append(UIImage(named: "activity\(i)")!)
        }
        
        let activityImage = UIImageView()
        activityImage.animationImages = imagesArray
        activityImage.animationDuration = TimeInterval(0.7)
        activityImage.startAnimating()
        
        self.addSubview(activityImage)
        activityImage.translatesAutoresizingMaskIntoConstraints = false
        activityImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return self }
}
