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
    var viewModel: CalendarViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = self.viewModel else { return }
        self.view.backgroundColor = viewModel.backgroundColor
        
        view.addSubview(viewModel.calendarView)
        viewModel.calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        viewModel.calendarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        viewModel.calendarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        viewModel.calendarView.heightAnchor.constraint(equalToConstant: 365).isActive = true
        
        viewModel.calendarView.myCollectionView.delegate = self
        viewModel.calendarView.myCollectionView.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel?.calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    //    MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection(section) ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCell
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! CalendarCellViewModel
        cell.viewModel = cellViewModel
        
        if cellViewModel.isCellSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }

        return cell
    }
    
    //    MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        
        guard let viewModel = viewModel else { return }
        viewModel.selectItem(atIndexPath: indexPath)
        
        cell.viewModel = viewModel.viewModelForSelectedItem()
        
        let date = cell.viewModel?.getDate(indexPath)
        if let date = date {
            viewModel.currentWorklogDate = String.dateFormatter.string(from: date)
            callback?(viewModel.currentWorklogDate)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)  as! CalendarCell
        
        guard let viewModel = viewModel else { return }
        viewModel.selectItem(atIndexPath: indexPath)
        
        cell.viewModel = viewModel.viewModelForDeselectedItem()
    }
        
    //    MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.sizeForItem(collectionView) ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.spacingForSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.spacingForSection() ?? 0
    }
    
}

