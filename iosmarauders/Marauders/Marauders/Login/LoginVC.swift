//
//  LoginVC.swift
//  Marauders
//
//  Created by somsak on 26/1/2564 BE.
//

import Foundation
import UIKit
import GoogleSignIn
import FBSDKLoginKit
import LineSDK
import AuthenticationServices

class LoginVC: BaseVC, LoginModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHiddenBTN: UIButton!
    @IBOutlet weak var lineView: IBDesignableView!
    @IBOutlet weak var appleView: IBDesignableView!
    
    
    
    var googleSignIn = GIDSignIn.sharedInstance()
    private var viewModel: LoginModel!
    let loginButton = LoginButton()
    let authorizationButton = ASAuthorizationAppleIDButton()
    
    var passwordHidden = true

    override func viewDidLoad(){
        super.viewDidLoad()

        self.viewModel = LoginModel(view: self)
        self.lineView.addSubview(loginButton)
        
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        
        appleView.addSubview(authorizationButton)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        
//        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
//            self.alert(title: "Please enter a username and password.") { (bool) in }
//        }else{
//            login()
//        }
        
        redirectView()
    }
    
    @IBAction func appleLogin(_ sender: Any) {
        
    }
    
    
    func login(){
        self.startLoading()
        self.viewModel.login(
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        )
    }
    
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        self.googleAuthLogin()
//        didFinishgoogleAuthLogin()
    }
    
    @IBAction func facebookLoginBtnAction(_ sender: UIButton) {
        self.facebookAuthLogin()
    }

    func googleAuthLogin() {
//        self.googleSignIn?.presentingViewController = self
//        self.googleSignIn?.clientID = "69307359716-vdnamal5866cpk7ohiqa8073h5qcql2a.apps.googleusercontent.com"
//        self.googleSignIn?.delegate = self
//        self.googleSignIn?.signIn()
        
        
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        
    }
    
    func didFinishLogin(_ status: StatusWebServiceEnum) {
        self.startLoading()

        switch status {
        case .success:
            self.alert(title: "Login success."){(bool) in
                self.redirectView()
            }
            break
        case .badRequest:
            self.alert(title: "Failed to login."){(bool) in }
            break
        default:
            break
        }
    }
    
    func facebookAuthLogin(){
        
//        let loginManager = LoginManager()
//
//        if let _ = AccessToken.current {
//            // Access token available -- user already logged in
//            // Perform log out
//
//            // 2
//            loginManager.logOut()
//
//        } else {
//            // Access token not available -- user already logged out
//            // Perform log in
//
//            // 3
//            loginManager.logIn(permissions: ["email","public_profile"], from: self) {(result, error) in
//
//                print("\n\n result: \(result)")
//
//                if (error == nil) {
//                    let fbloginresult : LoginManagerLoginResult = result!
//                    if(fbloginresult.isCancelled) {
//                        //Show Cancel alert
//                    } else if(fbloginresult.grantedPermissions.contains("email")) {
//                        self.returnUserData()
//                        //fbLoginManager.logOut()
//                    }
//                }
//
//                // 4
//                // Check for error
//                guard error == nil else {
//                    // Error occurred
//                    print(error!.localizedDescription)
//                    return
//                }
//
//                // 5
//                // Check for cancel
//                guard let result = result, !result.isCancelled else {
//                    print("User cancelled login")
//                    return
//                }
//
//                // Successfully logged in
//                // 6
//                print("isLoggedIn", true)
//
//                // 7
//                Profile.loadCurrentProfile { (profile, error) in
//                    print("Profile.current?.name", Profile.current?.name as Any)
//                    print("Profile.current?.name", Profile.current?.email as Any)
//                    print("Profile.current?.name", Profile.current?.userID as Any)
//                }
//            }
//        }
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: [.publicProfile, .email, .userBirthday, .userGender, .userHometown], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("error", error)
                
                break
            case .cancelled:
                break
            case .success( _, _, let accessToken):
                print(accessToken!.tokenString)
                self.facebookRequest(accessTokenTokenString: accessToken!.tokenString)
                break
            }
        }

    }
    
    func facebookRequest(accessTokenTokenString: String) {
        let request = GraphRequest.init(graphPath: "/me", parameters:  ["fields" : "id,email,name,first_name,last_name,gender,birthday,hometown,picture.type(large)"], tokenString: accessTokenTokenString, version: "", httpMethod: .get)
        request.start(completionHandler: {connection,data,error in
            print("connection", connection)
            print("data", data)
            print("error", error)
            if let info = data as? [String : AnyObject] {
                
                self.facebookResponse(data: info)
            }
            
        })
    }
    
    func facebookResponse(data:[String : AnyObject]) {
        var md5: String!
        let id = data["id"] as! String
        
            print("id:",id)
        if let email = data["email"] as? String {
            print("email:",email)
            
        }
        
        var address = ""
        if let homeTownDict = data["hometown"] as! NSDictionary? {
            address = homeTownDict["name"] as! String
            print("address",address)
        }
        let profileUrl = URL.init(string: ((data["picture"] as! [String: Any])["data"] as! [String: Any])["url"] as! String)
                                           print(data["first_name"] as! String)
        print(data["last_name"] as! String)
        print(data["birthday"] as? String)
        print(data["gender"] as? String)
    }

    
    func didFinishgoogleAuthLogin(){
        redirectView()
    }
    
    func redirectView(){
        
        UserDefaults.standard.set(true, forKey: "status")
        let userModel = UserModel(accessToken: "12345999")
        UserCoreData().saveUserData(userData: userModel)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController()
    }
}

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard let user = user else {
            print("Uh oh. The user cancelled the Google login.")
            return
        }
        
        let userId = user.userID ?? ""
        print("Google User ID: \(userId)")
        
        let userIdToken = user.authentication.idToken ?? ""
        print("Google ID Token: \(userIdToken)")
        
        let userFirstName = user.profile.givenName ?? ""
        print("Google User First Name: \(userFirstName)")
        
        let userLastName = user.profile.familyName ?? ""
        print("Google User Last Name: \(userLastName)")
        
        let userEmail = user.profile.email ?? ""
        print("Google User Email: \(userEmail)")
        
        let googleProfilePicURL = user.profile.imageURL(withDimension: 150)?.absoluteString ?? ""
        print("Google Profile Avatar URL: \(googleProfilePicURL)")
        
//        didFinishgoogleAuthLogin()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

//MARK: - LineLogin

extension LoginVC: LineSDK.LoginButtonDelegate {
    
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LineSDK.LoginResult) {
//        self.presenter?.lineSignin(loginResult)
        print("loginResult", loginResult)
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        print("didFailLogin: \(error.errorDescription ?? "")")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("loginButtonDidStartLogin")
    }
}

//MARK: - AppleID

extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
            
//            self.presenter?.saveAppleId(withCredential: appleIDCredential)
        print("appleIDCredential", appleIDCredential)
                    
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
}
