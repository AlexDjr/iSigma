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
        if userView.alpha == 1.0 {
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
                showAlert("Укажите свой e-mail!")
            }
        }
        
        if pinTextField.alpha == 1.0 {
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
                showAlert("Укажите PIN-код!")
            }
        }
    }
    
    //    MARK: - Methods
    fileprivate func setupView() {
        hideSteps()
        startSpinner()
        
        NetworkManager.shared.authCheck { isOk, errorDescription in
            self.stopSpinner()
            if errorDescription != nil {
                print("STATUS: Network error!")
                self.showError(errorDescription!)
            } else {
                let userDefaults = UserDefaults.standard
                let keychain = KeychainWrapper.standard
                if isOk && userDefaults.value(forKey: "isLoggedIn") != nil && userDefaults.bool(forKey: "isLoggedIn") && keychain.string(forKey: "accessToken") != nil {
                    print("STATUS: Authorization is OK! and isLoggedIn!")
                    self.openApp()
                } else {
                    print("STATUS: Authorization is NOT OK! or LoggedIn expired!")
                    self.showUserStep()
                }
            }
        }
    }
    
    fileprivate func openApp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.hideSteps()
            }, completion: { isFinished in
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
            })
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
            UIView.animate(withDuration: 0.5) {
                self.errorImage.alpha = 1.0
                self.error.alpha = 1.0
                self.errorDescription.alpha = 1.0
            }
        }
    }
    
    fileprivate func hideSteps() {
        userView.alpha = 0.0
        userDescription.alpha = 0.0
        pinTextField.alpha = 0.0
        pinDescriptionMain.alpha = 0.0
        pinDescriptionSecondary.alpha = 0.0
        errorImage.alpha = 0.0
        error.alpha = 0.0
        errorDescription.alpha = 0.0
        submitButton.alpha = 0.0
    }
    
    fileprivate func showUserStep() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.userView.alpha = 1.0
                self.userDescription.alpha = 1.0
                self.submitButton.alpha = 1.0
            }
            self.pinTextField.alpha = 0.0
            self.pinDescriptionMain.alpha = 0.0
            self.pinDescriptionSecondary.alpha = 0.0
        }
    }
    
    fileprivate func showPinStep() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.userView.alpha = 0.0
                self.userDescription.alpha = 0.0
                self.submitButton.alpha = 0.0
            }, completion: { isFinished in
                UIView.animate(withDuration: 0.5) {
                    self.pinTextField.alpha = 1.0
                    self.pinDescriptionMain.alpha = 1.0
                    self.pinDescriptionSecondary.alpha = 1.0
                    self.submitButton.alpha = 1.0
                }
            })
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
