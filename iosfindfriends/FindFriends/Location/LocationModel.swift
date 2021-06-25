//
//  LocationModel.swift
//  FindFriends
//
//  Created by somsak on 18/1/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol LocationModelDelegate {
    func didFinishSendLocation(_ status: statusWebService, code: String)
}

class LocationModel{

    private var locationModelDelegate: LocationModelDelegate?

    init(view: LocationModelDelegate) {
        self.locationModelDelegate = view
    }
    
    func sendLocation(latitude: Double, longitude: Double){
        
        let service = ServiceWrapper()
        let parameters: Parameters = ["latitude": latitude, "longitude": longitude]
        var urlRequest = URLRequest(url:  URL(string: WebServiceURL.location)!)
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
                
                self.locationModelDelegate?.didFinishSendLocation(.success, code: data.rawString()!)
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
}
