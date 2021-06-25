//
//  RegisterVC.swift
//  Marauders
//
//  Created by somsak on 18/2/2564 BE.
//

import UIKit

class RegisterVC: BaseVC, RegisterModelDelegate {
    
    var getEmailOnTextField:(() -> (String))!
    var getPasswordOnTextField:(() -> (String))!
    var getConfirmPasswordOnTextField:(() -> (String))!
    
    var registerData = [String]()
    var passwordHidden = [true, true]
    
    private var viewModel: RegisterModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegisterModel(view: self)

        self.title = "Register"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func authentication(){
        self.registerData = [String]()
        self.registerData.append(self.getEmailOnTextField())
        self.registerData.append(self.getPasswordOnTextField())
        self.registerData.append(self.getConfirmPasswordOnTextField())
        
        let isDataEmpty = self.registerData.contains {$0 == ""}
        if isDataEmpty {
            self.alert(title: "Data is empty."){(bool) in}
        }else{
            if self.getPasswordOnTextField() == self.getConfirmPasswordOnTextField() {
                self.startLoading()
                self.viewModel.authentication(data: self.registerData)
            }else{
                self.incorrectPassword()
            }
        }
    }
    
    func incorrectPassword(){
        self.alert(title: "Incorrect password"){(bool) in}
    }
    
    func didFinishAuthentication(_ status: StatusWebServiceEnum, code: String) {
        print("code", code)
        self.stopLoading()
        
        switch status {
        case .success:
            self.inputTextFieldsAlert(title: "Check your email.", message: "We have sent you a verification code, please verify your email address.", placeholder: "Verification code."){(myCode) in
                
                if myCode != nil {
                    if myCode == code {
                        self.viewModel.register(data: self.registerData)
                    }else{
                        self.alert(title: "Incorrect code"){(bool) in
                            if bool {
                                self.didFinishAuthentication(.success, code: code)
                            }
                        }
                    }
                }else{
                    self.startLoading()
                    self.viewModel.authentication(data: self.registerData)
                }
            }
            break
        case .badRequest:
            self.alert(title: "Verification code."){(bool) in }
            break
        default:
            break
        }
    }
    
    func didFinishRegister(_ status: StatusWebServiceEnum) {
        self.stopLoading()
        switch status {
        case .success:
            self.alert(title: "Register success."){(bool) in
                self.navigationController?.popViewController(animated: true)
            }
            break
        case .badRequest:
            self.alert(title: "Failed to register."){(bool) in }
            break
        default:
            break
        }
    }
}

extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = RegisterTableViewCell()
        
        switch indexPath.row {
        case 0:
            let emailCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! RegisterTableViewCell
            
            self.getEmailOnTextField = {
                return emailCell.emailTextField.text!
            }
            
            cell = emailCell
        case 1:
            let passwordCell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! RegisterTableViewCell
            
            self.getPasswordOnTextField = {
                return passwordCell.passwordTextField.text!
            }
            
            passwordCell.didTapPasswordHidden = {() in
                if self.passwordHidden.first! {
                    self.passwordHidden[0] = false
                    passwordCell.passwordHiddenBTN.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                    passwordCell.passwordTextField.isSecureTextEntry = false
                }else{
                    self.passwordHidden[0] = true
                    passwordCell.passwordHiddenBTN.setImage(UIImage(systemName: "eye"), for: .normal)
                    passwordCell.passwordTextField.isSecureTextEntry = true
                }
            }
            
            cell = passwordCell
        case 2:
            let confirmPasswordCell = tableView.dequeueReusableCell(withIdentifier: "confirmPasswordCell", for: indexPath) as! RegisterTableViewCell
            
            self.getConfirmPasswordOnTextField = {
                return confirmPasswordCell.confirmPasswordTextField.text!
            }
            
            confirmPasswordCell.didTapConfirmPasswordHidden = {() in
                if self.passwordHidden.last! {
                    self.passwordHidden[1] = false
                    confirmPasswordCell.confirmPasswordHiddenBTN.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                    confirmPasswordCell.confirmPasswordTextField.isSecureTextEntry = false
                }else{
                    self.passwordHidden[1] = true
                    confirmPasswordCell.confirmPasswordHiddenBTN.setImage(UIImage(systemName: "eye"), for: .normal)
                    confirmPasswordCell.confirmPasswordTextField.isSecureTextEntry = true
                }
            }
            
            cell = confirmPasswordCell
        case 3:
            let registerCell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! RegisterTableViewCell
            
            cell = registerCell
            
            registerCell.didTapRegister = {() in
                self.authentication()
            }
        default:
            break
        }
        
        return cell
    }
}

