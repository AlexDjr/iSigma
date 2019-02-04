//
//  AssigneesController.swift
//  iSigma
//
//  Created by Alex Delin on 03/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AssigneesController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: AssigneesViewModel?
    var callback: ((Employee) -> ())?
    let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.hidesWhenStopped = true
        return view
    }()
    var loadingView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AssigneesViewModel()
        
        setLoadingScreen()
        viewModel?.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
                self.removeLoadingScreen(false)
            }
        }
        viewModel?.getEmployees{ employees in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.removeLoadingScreen(true)
            }
        }
    }
    
    //    MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assigneeCell", for: indexPath) as? AssigneeCell
        
        guard let assigneeCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        assigneeCell.viewModel = cellViewModel
        
        return assigneeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath) else { return }
        callback?(cellViewModel.employee)
    }
    
    private func setLoadingScreen() {
        spinner.startAnimating()
        loadingView = Utils.getLoadingView(view: view, spinner: spinner)
        collectionView.isScrollEnabled = false
        collectionView.alpha = 0.0
        
    }
    
    private func removeLoadingScreen(_ isOk: Bool) {
        spinner.stopAnimating()
        loadingView.isHidden = true
        if isOk {
            collectionView.isScrollEnabled = true
            collectionView.alpha = 1.0
        }
    }
    
    
}
