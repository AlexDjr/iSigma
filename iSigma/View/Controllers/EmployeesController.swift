//
//  EmployeesController.swift
//  iSigma
//
//  Created by Alex Delin on 12/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EmployeesViewModel?
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
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //    this (plus constraints to superview for tableView in storyboard) fixes strange scrolling behavior when tapping on status bar
        extendedLayoutIncludesOpaqueBars = true
        viewModel = EmployeesViewModel()
        
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
                self.tableView.reloadData()
                self.removeLoadingScreen(true)
            }
        }
        
        setupSearchController()
    }

    //    MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section, isFiltering: isFiltering) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as? EmployeeCell
        
        guard let employeeCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath, isFiltering: isFiltering)
        employeeCell.viewModel = cellViewModel
        
        return employeeCell
    }
    
    //    MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let employeeInfoController = storyboard.instantiateViewController(withIdentifier: "employeeInfoController") as! EmployeeInfoController
        
        guard let viewModel = viewModel else { return }
        let employees = viewModel.getDataSource(isFiltering)
        employeeInfoController.navigationItem.title = "Сотрудник"
        employeeInfoController.viewModel = EmployeeInfoViewModel(employee: employees[indexPath.row])
        navigationController?.pushViewController(employeeInfoController, animated: true)
    }
    
    //    MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let viewModel = viewModel else { return }
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        viewModel.filterContentForSearchText(searchBar.text!, searchBarIsEmpty: searchBarIsEmpty, scope: scope)
        tableView.reloadData()
    }
    
    //    MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let viewModel = viewModel else { return }
        viewModel.filterContentForSearchText(searchBar.text!, searchBarIsEmpty: searchBarIsEmpty, scope: searchBar.scopeButtonTitles![selectedScope])
        tableView.reloadData()
    }
    
    //    MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    //    MARK: - Methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = AppStyle.whiteTextColor
        searchController.searchBar.placeholder = "Поиск..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Все", "Отдел/Команда", "Департамент"]
        searchController.searchBar.delegate = self
        //    changing width of first element so all titles would fit in
        if let segmentedControl = searchController.searchBar.searchSubviewForViewOfKind(UISegmentedControl.self) as? UISegmentedControl {
            segmentedControl.setWidth(64, forSegmentAt: 0)
        }
    }
    
    private func setLoadingScreen() {
        spinner.startAnimating()
        loadingView = Utils.getLoadingView(view: view, spinner: spinner)
        tableView.isScrollEnabled = false
        tableView.alpha = 0.0
        
    }
    
    private func removeLoadingScreen(_ isOk: Bool) {
        spinner.stopAnimating()
        loadingView.isHidden = true
        if isOk {
            tableView.isScrollEnabled = true
            tableView.alpha = 1.0
        }
    }
}
