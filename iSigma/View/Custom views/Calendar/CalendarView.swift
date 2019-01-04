//
//  CalendarView.swift
//  iSigma
//
//  Created by Muskan on 10/22/17.
//  Modified by Alex Delin on 30/12/18.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
    static var monthViewBtnRightColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
    static var monthViewBtnLeftColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
    static var weekdaysLblColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
}

class CalendarView: UIView, MonthViewDelegate {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    var selectedDate: String?

    lazy var monthView: MonthView = {
        let view = MonthView(selectedDate: self.selectedDate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weekdaysView: WeekdaysView = {
        let view = WeekdaysView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(selectedDate: String?) {
        self.init()
        self.selectedDate = selectedDate
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


  
    
    //    MARK: - Methods
    func setupView() {
        var date = Date()
        if let selectedDate = selectedDate {
            date = selectedDate.date!
        }
        currentMonthIndex = Calendar.current.component(.month, from: date)
        currentYear = Calendar.current.component(.year, from: date)
        todaysDate = Calendar.current.component(.day, from: date)
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //    calculate number of days for February
        if currentMonthIndex == 2 {
            numOfDaysInMonth[currentMonthIndex - 1] = leapDays(currentYear)
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupViews()
        
        myCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func getFirstWeekDay() -> Int {
        //    returns number of weekday (Sunday-Saturday 1-7)
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        if day == 1 {
            return day + 5
        } else {
            return day - 2
        }
    }
    
    func leapDays(_ year: Int) -> Int {
        if year % 4 == 0 && (year % 100 != 0 || (year % 100 == 0 && year % 400 == 0)) {
            return 29
        }
        return 28
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        //    calculate number of days for February
        if monthIndex == 1 {
            numOfDaysInMonth[monthIndex] = leapDays(currentYear)
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        myCollectionView.reloadData()
//        UIView.animate(withDuration: 1) {
//            self.subviews[2].layer.backgroundColor = UIColor.green.cgColor
//        }
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
