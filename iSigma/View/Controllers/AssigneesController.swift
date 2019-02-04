//
//  AssigneesController.swift
//  iSigma
//
//  Created by Alex Delin on 03/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AssigneesController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scopeControl: UISegmentedControl!
    @IBOutlet weak var cancelButton: UIButton!
    
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
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering = true
    
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
                self.filterAndReload()
                self.removeLoadingScreen(true)
            }
        }
        setupSearchController()
    }
    
    //    MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section, isFiltering: isFiltering) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assigneeCell", for: indexPath) as? AssigneeCell
        
        guard let assigneeCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath, isFiltering: isFiltering)
        assigneeCell.viewModel = cellViewModel
        
        return assigneeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.cellViewModel(forIndexPath: indexPath, isFiltering: isFiltering) else { return }
        callback?(cellViewModel.employee)
    }
    
    //    MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFiltering = true;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true;
        filterAndReload()
    }
    
    //    MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    //    MARK: - Methods
    private func setupSearchController() {
        searchBar.delegate = self
        scopeControl.selectedSegmentIndex = 1
        scopeControl.addTarget(self, action: #selector(scopeChanged), for: .valueChanged)
        cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
    }
    
    @objc private func scopeChanged() {
        if scopeControl.selectedSegmentIndex == 0 && searchBarIsEmpty {
            isFiltering = false
        } else {
            isFiltering = true
        }
        filterAndReload()
    }
    
    @objc private func cancelSearch() {
        searchBar.text = nil
        searchBar.endEditing(true)
        filterAndReload()
    }
    
    private func filterAndReload() {
        guard let viewModel = viewModel else { return }
        let scope = scopeControl.titleForSegment(at: scopeControl.selectedSegmentIndex)!
        viewModel.filterContentForSearchText(searchBar.text!, searchBarIsEmpty: searchBarIsEmpty, scope: scope)
        collectionView.reloadData()
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
