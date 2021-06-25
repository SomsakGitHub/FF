//
//  ForgotPasswordModel.swift
//  FindFriends
//
//  Created by somsak on 15/1/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol ForgotPasswordModelDelegate{
    func didFinishForgotPassword(_ status: statusWebService)
}

class ForgotPasswordModel{

    private var forgotPasswordModelDelegate: ForgotPasswordModelDelegate?

    init(view: ForgotPasswordModelDelegate) {
        self.forgotPasswordModelDelegate = view
    }
    
    func forgotPassword(email: String){
        
        print("email", email)
        
        let service = ServiceWrapper()
        let parameters: Parameters = ["email": email]
        var urlRequest = URLRequest(url:  URL(string: WebServiceURL.forgotPassword)!)
        urlRequest.httpMethod = HTTPMethod.patch.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10 // secs
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        service.serviceResponse(request: urlRequest) { (response, status) in
            self.forgotPasswordModelDelegate?.didFinishForgotPassword(status)
        }
    }
}
