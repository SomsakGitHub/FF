//
//  SplashVC.swift
//  Marauders
//
//  Created by somsak on 11/2/2564 BE.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView()
    }
    
    func mainView(){
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController()
    }
}
