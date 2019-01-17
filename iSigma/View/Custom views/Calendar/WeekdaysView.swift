//
//  WeekdaysView.swift
//  iSigma
//
//  Created by Muskan on 10/22/17.
//  Modified by Alex Delin on 30/12/18.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    func setupViews() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        for i in 0..<7 {
            let label = UILabel()
            if i == 6 {    // shortStandaloneWeekdaySymbols starts from Sunday
                label.text = String.dateFormatter.shortStandaloneWeekdaySymbols[0].capitalized
            } else {
                label.text = String.dateFormatter.shortStandaloneWeekdaySymbols[i+1].capitalized
            }
            label.textAlignment = .center
            label.textColor = AppStyle.mainRedColor
            stackView.addArrangedSubview(label)
        }
    }
}
