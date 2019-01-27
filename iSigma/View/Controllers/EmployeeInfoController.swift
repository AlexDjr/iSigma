//
//  EmployeeInfoController.swift
//  iSigma
//
//  Created by Alex Delin on 15/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeeInfoController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var middleName: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var branch: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var skype: UILabel!
    @IBOutlet weak var headFullName: UILabel!
    @IBOutlet weak var topDepartment: UILabel!
    @IBOutlet weak var department: UILabel!
    
    var viewModel: EmployeeInfoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        
        photo.image = viewModel.photo
        lastName.text = viewModel.lastName
        firstName.text = viewModel.firstName
        middleName.text = viewModel.middleName
        position.text = viewModel.position
        branch.text = viewModel.branch
        mobile.text = viewModel.mobile
        mobile.textColor = viewModel.mobileTextColor
        room.text = viewModel.room
        phone.text = viewModel.phone
        skype.text = viewModel.skype
        skype.textColor = viewModel.skypeTextColor
        headFullName.text = viewModel.headFullName
        headFullName.textColor = viewModel.headFullNameTextColor
        topDepartment.text = viewModel.topDepartment
        department.text = viewModel.department
        
        if viewModel.email != "" {
            let emailButton = UIBarButtonItem(image: UIImage(named: "email"), style: .plain, target: self, action: #selector(sendEmail))
            self.navigationItem.rightBarButtonItem  = emailButton
        }
        
        if viewModel.mobile != "" {
            mobile.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeACall))
            mobile.addGestureRecognizer(gestureRecognizer)
        }
        
        if viewModel.skype != "" {
            skype.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeASkypeCall))
            skype.addGestureRecognizer(gestureRecognizer)
        }
        
        if viewModel.headFullName != "" {
            headFullName.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showEmployee))
            headFullName.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    @objc func sendEmail() {
        guard let email = viewModel?.email else { return }
        Utils.sendEmail(email)
    }
    
    @objc func makeACall() {
        guard let mobile = viewModel?.mobile else { return }
        Utils.makeACall(mobile)
    }
    
    @objc func makeASkypeCall() {
        guard let skype = viewModel?.skype else { return }
        Utils.makeASkypeCall(skype)
    }
    
    @objc func showEmployee() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
            }
        }
        
        viewModel.getEmployees { employees in
            let employee = employees!.first { (employee) -> Bool in
                employee.id == viewModel.headId
            }
            
            if let employee = employee {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let employeeInfoController = storyboard.instantiateViewController(withIdentifier: "employeeInfoController") as! EmployeeInfoController
                employeeInfoController.navigationItem.title = "Руководитель"
                employeeInfoController.viewModel = EmployeeInfoViewModel(employee: employee)
                self.navigationController?.pushViewController(employeeInfoController, animated: true)
            } else {
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "ОК", style: .default)
                    self.presentAlert(title: "Ошибка!", message: "Данный сотрудник не доступен", actions: okAction)
                }
            }
        }
    }

}
