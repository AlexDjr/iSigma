//
//  CalendarViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 04/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class CalendarViewModel {
    var currentWorklogDate: String?
    private var selectedIndexPath: IndexPath?
    
    var backgroundColor: UIColor
    
    lazy var calendarView : CalendarView = {
        let view = CalendarView(selectedDate: self.currentWorklogDate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(selectedDate: String) {
        self.currentWorklogDate = selectedDate
        self.backgroundColor = UIColor.white
    }
    
    //    MARK: - UICollectionViewDataSource
    func numberOfItemsInSection(_ section: Int) -> Int {
        return calendarView.numOfDaysInMonth[calendarView.currentMonthIndex - 1] + calendarView.firstWeekDayOfMonth
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelProtocol? {
        return CalendarCellViewModel(indexPath: indexPath, calendarView: calendarView, selectedDate: currentWorklogDate, selection: nil)
    }
    
    //    MARK: UICollectionViewDelegateFlowLayout
    func sizeForItem(_ collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.width / 7 - spacingForSection()
        let height = collectionView.frame.width / 7 - spacingForSection()
        return CGSize(width: width, height: height)
    }
    
    func spacingForSection() -> CGFloat {
        return 8.0
    }
    
    //    MARK: - Methods
    func viewModelForSelectedItem() -> CalendarCellViewModel? {
        guard let selectedIndexPath = selectedIndexPath, let currentWorklogDate = currentWorklogDate else { return nil }
        return CalendarCellViewModel(indexPath: selectedIndexPath, calendarView: calendarView, selectedDate: currentWorklogDate, selection: true)
    }
    
    func viewModelForDeselectedItem() -> CalendarCellViewModel? {
        guard let selectedIndexPath = selectedIndexPath, let currentWorklogDate = currentWorklogDate else { return nil }
        return CalendarCellViewModel(indexPath: selectedIndexPath, calendarView: calendarView, selectedDate: currentWorklogDate, selection: false)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
}
