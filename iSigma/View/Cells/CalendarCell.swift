//
//  CalendarCell.swift
//  iSigma
//
//  Created by Alex Delin on 29/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var viewModel: CalendarCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            let label = self.subviews[1] as! UILabel
            label.text = viewModel.dayNumber
            label.textColor = viewModel.dayTextColor
            self.isHidden = viewModel.cellIsHidden
            self.backgroundColor = viewModel.cellBGColor
            self.layer.borderColor = viewModel.cellBorderColor
            self.layer.borderWidth = viewModel.cellBorderWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.height / 2
//        layer.masksToBounds = true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    func setupViews() {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
