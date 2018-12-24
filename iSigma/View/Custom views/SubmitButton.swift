//
//  SubmitButton.swift
//  iSigma
//
//  Created by Alex Delin on 24/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class SubmitButton: UIButton  {
    
    var highlightedColor: CGColor!
    var bgColor: CGColor!
    
    weak var viewModel: SubmitButtonViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            self.layer.borderWidth = viewModel.borderWidth
            self.layer.borderColor = viewModel.tintColor.cgColor
            self.layer.cornerRadius = viewModel.cornerRadius
            
            highlightedColor = viewModel.tintColor.withAlphaComponent(0.05).cgColor
            bgColor = viewModel.bgColor.cgColor
            
            self.backgroundColor = viewModel.bgColor
            self.setTitle("Списаться", for: .normal)
            self.setTitleColor(viewModel.tintColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.backgroundColor = highlightedColor
            } else {
                layer.backgroundColor = bgColor
            }
        }
    }
}
