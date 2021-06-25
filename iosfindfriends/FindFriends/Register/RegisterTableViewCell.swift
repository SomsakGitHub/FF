//
//  RegisterTableViewCell.swift
//  FindFriends
//
//  Created by somsak.kaeworasan on 25/12/2563 BE.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordHiddenBTN: UIButton!
    @IBOutlet weak var confirmPasswordHiddenBTN: UIButton!
    
    var didTapRegister:( ()-> Void ) = {}
    var didTapPasswordHidden:( ()-> Void ) = {}
    var didTapConfirmPasswordHidden:( ()-> Void ) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func registerAction(_ sender: Any) {
        self.didTapRegister()
    }
    
    @IBAction func passwordHidden(_ sender: Any) {
        self.didTapPasswordHidden()
    }
    
    @IBAction func confirmPasswordHidden(_ sender: Any) {
        self.didTapConfirmPasswordHidden()
    }
}
