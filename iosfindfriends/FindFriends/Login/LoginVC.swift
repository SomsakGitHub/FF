//
//  LoginVC.swift
//  FindFriends
//
//  Created by somsak.kaeworasan on 25/12/2563 BE.
//

import UIKit

class LoginVC: BaseViewController, LoginModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHiddenBTN: UIButton!
    
    private var viewModel: LoginModel!
    var passwordHidden = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = LoginModel(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func passwordHiddenAction(_ sender: Any) {
        if self.passwordHidden {
            self.passwordHidden = false
            self.passwordHiddenBTN.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordHidden = true
            self.passwordHiddenBTN.setImage(UIImage(systemName: "eye"), for: .normal)
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
//        self.performSegue(withIdentifier: "goToHome", sender: self)
        
//        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
//            self.alert(title: "Please enter a username and password.") { (bool) in }
//        }else{
//            login()
//        }
        
        login()
    }
    
    func login(){
        self.startAnimating()
        self.viewModel.login(
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        )
    }
    
    func didFinishLogin(_ status: statusWebService) {
        self.stopAnimating()

        switch status {
        case .success:
            self.alert(title: "Login success."){(bool) in
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
            break
        case .badRequest:
            self.alert(title: "Failed to login."){(bool) in }
            break
        default:
            break
        }
    }
}
