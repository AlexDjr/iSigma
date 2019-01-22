//
//  EmployeesController.swift
//  iSigma
//
//  Created by Alex Delin on 12/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EmployeesViewModel?
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EmployeesViewModel()
        
        viewModel?.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
            }
        }
        viewModel?.getEmployees{ employees in
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        viewModel.filteredContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
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
    }
}
