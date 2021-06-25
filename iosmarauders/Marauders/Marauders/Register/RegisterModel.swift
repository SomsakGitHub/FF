//
//  RegisterModel.swift
//  Marauders
//
//  Created by somsak on 18/2/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol RegisterModelDelegate {
    func didFinishAuthentication(_ status: StatusWebServiceEnum, code: String)
    func didFinishRegister(_ status: StatusWebServiceEnum)
}

class RegisterModel{

    private var registerModelDelegate: RegisterModelDelegate?

    init(view: RegisterModelDelegate) {
        self.registerModelDelegate = view
    }
    
    func authentication(data: [String]){
        print("data", data)
        
        let service = ServiceWrapper()
        let parameters: Parameters = ["email": data[0]]
        var urlRequest = URLRequest(url:  URL(string: WebServiceURL.authentication)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10 // secs
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        service.serviceResponse(request: urlRequest) { (response, status) in

            switch status {
            case .success:
                print("success")
                let json: JSON = JSON(response!)
                let data = json["code"]
                print("result", data)
                
                self.registerModelDelegate?.didFinishAuthentication(.success, code: data.rawString()!)
                break
            case .badRequest:

                break
            case nil:

                break
            default :
                break
                
            }
            
//            self.registerModelDelegate?.didFinishAuthentication(.success, code: "1234")
        }
    }
    
    func register(data: [String]){
        print("data", data)

        let passwordCrypto = data[1].sha512()
        print("sha: \(passwordCrypto)")
        
        let service = ServiceWrapper()
        let parameters: Parameters = ["email": data[0], "password": passwordCrypto]
        var urlRequest = URLRequest(url:  URL(string: WebServiceURL.register)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10 // secs
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        service.serviceResponse(request: urlRequest) { (response, status) in
            self.registerModelDelegate?.didFinishRegister(status)
        }
    }
}
