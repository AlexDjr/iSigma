//
//  UIView+activityIndicator.swift
//  iSigma
//
//  Created by Alex Delin on 07/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addActivityIndicator(withBlur: Bool) {
        let view = UIView()
        if withBlur {
            view.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        }
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        var imagesArray = [UIImage(named: "activity\(0)")!]
        for i in 1..<30 {
            imagesArray.append(UIImage(named: "activity\(i)")!)
        }
        
        let activityImage = UIImageView()
        activityImage.animationImages = imagesArray
        activityImage.animationDuration = TimeInterval(0.7)
        activityImage.startAnimating()
        
        view.addSubview(activityImage)
        activityImage.translatesAutoresizingMaskIntoConstraints = false
        activityImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func removeActivityIndicator() {
        guard let lastSubView = self.subviews.last else { return }
        lastSubView.removeFromSuperview()
    }
}
