//
//  CalendarController.swift
//  iSigma
//
//  Created by Muskan on 10/22/17.
//  Modified by Alex Delin on 30/12/18.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class CalendarController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var callback: ((String?) -> ())?
    var currentWorklogDate: String?
    
    lazy var calendarView : CalendarView = {
        let view = CalendarView(selectedDate: self.currentWorklogDate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Style.bgColor
        
        view.addSubview(calendarView)
        calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: 365).isActive = true
        
        calendarView.myCollectionView.delegate = self
        calendarView.myCollectionView.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    //    MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarView.numOfDaysInMonth[calendarView.currentMonthIndex - 1] + calendarView.firstWeekDayOfMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCell
        
        if indexPath.item <= calendarView.firstWeekDayOfMonth - 1 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - calendarView.firstWeekDayOfMonth + 1
            cell.isHidden = false
            cell.lbl.text = "\(calcDate)"
            
            if let currentWorklogDate = currentWorklogDate {
                if currentWorklogDate.date == getDate(indexPath) {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                    setSelected(cell)
                } else {
                    if isToday(indexPath) {
                        setSelectedToday(cell)
                    } else {
                        setDeselected(cell)
                    }
                }
            }
        }
        return cell
    }
    
    
    //    MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            setSelected(cell)
        }
        
        let currentDayIndex = indexPath.item - calendarView.firstWeekDayOfMonth + 1
        let date = "\(calendarView.currentYear)-\(calendarView.currentMonthIndex)-\(currentDayIndex)".date
        if let date = date {
            currentWorklogDate = String.dateFormatter.string(from: date)
            callback?(currentWorklogDate)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell {
            if isToday(indexPath) {
                setSelectedToday(cell)
            } else {
                setDeselected(cell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 8
        let height = collectionView.frame.width / 7 - 8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    //    MARK: - Methods
    func setSelected(_ cell: UICollectionViewCell) {
        cell.backgroundColor = Colors.darkRed
        let lbl = cell.subviews[1] as! UILabel
        lbl.textColor = UIColor.white
    }
    
    func setDeselected(_ cell: UICollectionViewCell) {
        cell.backgroundColor = UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        let lbl = cell.subviews[1] as! UILabel
        lbl.textColor = Colors.darkGray
    }
    
    func setSelectedToday(_ cell: UICollectionViewCell) {
        cell.backgroundColor = UIColor.clear
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = Colors.darkRed.cgColor
        let lbl = cell.subviews[1] as! UILabel
        lbl.textColor = Colors.darkGray
    }
    
    func isToday(_ indexPath: IndexPath) -> Bool {
        let currentDayIndex = indexPath.item - calendarView.firstWeekDayOfMonth + 1
        let calendarDate = "\(calendarView.currentYear)-\(calendarView.currentMonthIndex)-\(currentDayIndex)".date
        if calendarDate == String.dateFormatter.string(from:Date()).date {
            return true
        } else {
            return false
        }
    }
    
    func getDate(_ indexPath: IndexPath) -> Date {
        let currentDayIndex = indexPath.item - calendarView.firstWeekDayOfMonth + 1
        let date = "\(calendarView.currentYear)-\(calendarView.currentMonthIndex)-\(currentDayIndex)".date!
        return date
    }
    
}

