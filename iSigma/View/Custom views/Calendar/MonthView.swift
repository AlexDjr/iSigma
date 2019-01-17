//
//  MonthView.swift
//  iSigma
//
//  Created by Muskan on 10/22/17.
//  Modified by Alex Delin on 30/12/18.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class MonthView: UIView {
    var currentMonth = 0
    var currentYear = 0
    
    var delegate: CalendarDelegateProtocol?
    
    let monthName: UILabel = {
        let label = UILabel()
        label.textColor = AppStyle.mainRedColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(AppStyle.mainRedColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(AppStyle.mainRedColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(selectedDate: String?) {
        self.init()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    func setupViews() {
        self.addSubview(monthName)
        monthName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        monthName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        monthName.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(rightButton)
        rightButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(leftButton)
        leftButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    @objc func buttonLeftRightAction(sender: UIButton) {
        switch sender {
        case rightButton:
            delegate?.didChangeMonth(delta: 1)
        case leftButton:
            delegate?.didChangeMonth(delta: -1)
        default: break
        }
    }
}

