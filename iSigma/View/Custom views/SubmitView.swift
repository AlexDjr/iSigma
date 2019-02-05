//
//  SubmitView.swift
//  iSigma
//
//  Created by Alex Delin on 24/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class SubmitView: UIView {
    var submitButton: SubmitButton
    
    var delegate: SubmitDelegateProtocol?
    
    weak var viewModel: SubmitViewViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            self.layer.backgroundColor = viewModel.viewBGColor
            
            self.addSubview(submitButton)
            submitButton.translatesAutoresizingMaskIntoConstraints = false
            submitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: viewModel.buttonConstraintConst).isActive = true
            submitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -viewModel.buttonConstraintConst).isActive = true
            submitButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: viewModel.buttonConstraintConst).isActive = true
            submitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -viewModel.buttonConstraintConst).isActive = true
            
            let buttonViewModel = SubmitButtonViewModel()
            submitButton.viewModel = buttonViewModel
        }
    }
    
    init() {
        submitButton = SubmitButton.init(type: .custom)
        super.init(frame: CGRect.zero)
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func submitButtonAction() {
        delegate?.submitButtonAction()
    }
    
}
