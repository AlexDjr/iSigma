//
//  EmployeesController.swift
//  iSigma
//
//  Created by Alex Delin on 12/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //    MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
