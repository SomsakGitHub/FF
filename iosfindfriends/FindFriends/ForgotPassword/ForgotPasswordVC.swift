//
//  ForgotPasswordVC.swift
//  FindFriends
//
//  Created by somsak on 15/1/2564 BE.
//

import UIKit

class ForgotPasswordVC: BaseViewController, ForgotPasswordModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    private var viewModel: ForgotPasswordModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot password"
        self.navigationController?.navigationBar.isHidden = false
        self.viewModel = ForgotPasswordModel(view: self)
    }
    
    func didFinishForgotPassword(_ status: statusWebService) {
        
    }
    
    @IBAction func emailConfirmAction(_ sender: Any) {
        if self.emailTextField.text!.isEmpty {
            self.alert(title: "Please enter a email.") { (bool) in }
        }else{
            forgotPassword()
        }
    }

    func forgotPassword(){
        self.startAnimating()
        self.viewModel.forgotPassword(email: self.emailTextField.text!)
    }
}
