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
    var currentMonthIndex = 0
    var currentYear = 0
    var selectedDate: String?
    
    var delegate: CalendarDelegateProtocol?
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonLeftRightAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(selectedDate: String?) {
        self.init()
        self.selectedDate = selectedDate
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    func setupViews() {
        var date = Date()
        if let selectedDate = selectedDate {
            date = selectedDate.date!
        }
        currentMonthIndex = Calendar.current.component(.month, from: date) - 1
        currentYear = Calendar.current.component(.year, from: date)
        
        self.addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        monthLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        let monthName = String.dateFormatter.standaloneMonthSymbols[currentMonthIndex].capitalized
        monthLabel.text = "\(monthName) \(currentYear)"
        
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
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        case leftButton:
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        default: break
        }
        
        let monthName = String.dateFormatter.standaloneMonthSymbols[currentMonthIndex].capitalized
        monthLabel.text = "\(monthName) \(currentYear)"
        
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
}

