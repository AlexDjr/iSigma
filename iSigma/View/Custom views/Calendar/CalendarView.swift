//
//  CalendarView.swift
//  iSigma
//
//  Created by Muskan on 10/22/17.
//  Modified by Alex Delin on 30/12/18.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class CalendarView: UIView, CalendarDelegateProtocol {
    var numberOfDaysForCurrentMonth = 0
    var currentMonthIndex = 0
    var currentYear = 0
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
    
    let daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = false
        return collectionView
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

    //    MARK: - CalendarDelegateProtocol
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        numberOfDaysForCurrentMonth = getNumberOfDays(year: currentYear, month: currentMonthIndex)
        
        firstWeekDayOfMonth = getFirstWeekDay()

        daysCollectionView.reloadData()
        //        UIView.animate(withDuration: 0.4) {
        //            self.subviews[2].alpha = 0.0
        //            self.subviews[2].alpha = 1.0
        //        }
    }
    
    //    MARK: - Methods
    func setupView() {
        var date = Date()
        if let selectedDate = selectedDate {
            date = selectedDate.date!
        }
        currentMonthIndex = Calendar.current.component(.month, from: date)
        currentYear = Calendar.current.component(.year, from: date)
        numberOfDaysForCurrentMonth = getNumberOfDays(year: currentYear, month: currentMonthIndex)
        
        firstWeekDayOfMonth = getFirstWeekDay()
        
        setupViews()
        
        daysCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "Cell")
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
        
        addSubview(daysCollectionView)
        daysCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        daysCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        daysCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        daysCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func getFirstWeekDay() -> Int {
        //    returns number of weekday (Sunday - 1 ... Saturday - 7)
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.weekday)!
        //    modifies returned number to convenient one: Monday - 0 ... Sunday - 6
        if day == 1 {
            return day + 5
        } else {
            return day - 2
        }
    }

    func getNumberOfDays(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numberOfDays = range.count
        return numberOfDays
    }

}
