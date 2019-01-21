//
//  LoginController.swift
//  iSigma
//
//  Created by Alex Delin on 16/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userView: UIStackView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var pinDescriptionMain: UILabel!
    @IBOutlet weak var pinDescriptionSecondary: UILabel!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
    
    let spinner: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.style = .white
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.hidesWhenStopped = true
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTextField.delegate = self
        self.pinTextField.delegate = self
        
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillReturnFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //    MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //    MARK: - Actions
    @IBAction func submitButtonAction(_ sender: Any) {
        if !userView.isHidden {
            if let user = userTextField.text {
                NetworkManager.shared.auth(withUser: user) { errorDescription in
                    if let errorDescription = errorDescription {
                        self.showAlert(errorDescription)
                    } else {
                        print("Пин-код отправлен!")
                        self.showPinStep()
                    }
                }
            } else {
                print("Укажите свой e-mail!")
            }
        }
        
        if !pinTextField.isHidden {
            if let pin = pinTextField.text {
                NetworkManager.shared.authToken(withPin: pin) { errorDescription in
                    if let errorDescription = errorDescription {
                        self.showAlert(errorDescription)
                    } else {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.synchronize()
                    
                        self.openApp()
                    }
                }
            } else {
                print("Укажите PIN-код!")
            }
        }
    }
    
    //    MARK: - Methods
    fileprivate func setupView() {
        hideSteps()
        startSpinner()
        
        let userDefaults = UserDefaults.standard
        let keychainWrapper = KeychainWrapper.standard
        
        if userDefaults.value(forKey: "isLoggedIn") != nil && userDefaults.bool(forKey: "isLoggedIn") && keychainWrapper.string(forKey: "accessToken") != nil {
            print("STATUS: seems like isLoggedIn!")
            
            NetworkManager.shared.authCheck { isOk, errorDescription in
                self.stopSpinner()
                if errorDescription != nil {
                    print("STATUS: Network error!")
                    self.showError(errorDescription!)
                } else {
                    if isOk {
                        print("STATUS: Authorization is OK!")
                        self.openApp()
                    } else {
                        print("STATUS: Authorization is NOT OK!")
                        self.showUserStep()
                    }
                }
            }
        } else {
            print("STATUS: is NOT LoggedIn!")
            showUserStep()
        }
    }
    
    fileprivate func openApp() {
        let viewModel = TasksViewModel()
        
        viewModel.onErrorCallback = { description in
            self.showAlert(description)
        }
        viewModel.getTasksForCurrentUser { tasks in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                appDelegate.window?.rootViewController = tabBarController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    fileprivate func startSpinner() {
        spinner.startAnimating()
        spinner.center = view.center
        view.addSubview(spinner)
    }
    
    fileprivate func stopSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
    }
    
    fileprivate func showError(_ errorDescription: String) {
        DispatchQueue.main.async {
            self.errorDescription.text = errorDescription
            self.errorDescription.isHidden = false
            self.error.isHidden = false
            self.errorImage.isHidden = false
        }
    }
    
    fileprivate func hideSteps() {
        userView.isHidden = true
        userDescription.isHidden = true
        pinTextField.isHidden = true
        pinDescriptionMain.isHidden = true
        pinDescriptionSecondary.isHidden = true
        errorImage.isHidden = true
        error.isHidden = true
        errorDescription.isHidden = true
        submitButton.isHidden = true
    }
    
    fileprivate func showUserStep() {
        DispatchQueue.main.async {
            self.userView.isHidden = false
            self.userDescription.isHidden = false
            self.pinTextField.isHidden = true
            self.pinDescriptionMain.isHidden = true
            self.pinDescriptionSecondary.isHidden = true
            self.submitButton.isHidden = false
        }
    }
    
    fileprivate func showPinStep() {
        DispatchQueue.main.async {
            self.userView.isHidden = true
            self.userDescription.isHidden = true
            self.pinTextField.isHidden = false
            self.pinDescriptionMain.isHidden = false
            self.pinDescriptionSecondary.isHidden = false
            self.submitButton.isHidden = false
        }
    }
    
    fileprivate func showAlert(_ description: String) {
        DispatchQueue.main.async {
            let okAction = UIAlertAction(title: "ОК", style: .default)
            self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
        }
    }
    
    @objc func appWillReturnFromBackground() {
        setupView()
    }
    
}
