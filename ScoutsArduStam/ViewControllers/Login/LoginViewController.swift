//
//  ViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 06/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var TextFieldEmail: UITextField!
    @IBOutlet var TextFieldWachtwoord: UITextField!
    @IBOutlet var ButtonLogin: UIButton!
    @IBOutlet var ButtonRegistreer: UIButton!
    var dataController = DataController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.isHidden = true
        self.navigationItem.hidesBackButton = true
        ButtonRegistreer.layer.borderWidth = 1.0
        ButtonRegistreer.layer.cornerRadius = 5.0
        ButtonRegistreer.layer.borderColor = UIColor.systemBlue.cgColor
        ButtonLogin.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if dataController.userIsAuthenticated {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func validateEmail(email: String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)

    }

    @IBAction func Login(_ sender: Any) {
        TextFieldEmail.layer.borderWidth = 0
        TextFieldWachtwoord.layer.borderWidth = 0
        errorMessage.isHidden = true
        let doChecks = false

        if doChecks {

            if TextFieldEmail.text == "" {
                TextFieldEmail.layer.borderColor = UIColor.red.cgColor
                TextFieldEmail.layer.borderWidth = 1.0
                return
            }

            if !validateEmail(email: TextFieldEmail.text!) {
                TextFieldEmail.layer.borderColor = UIColor.red.cgColor
                TextFieldEmail.layer.borderWidth = 1.0
                errorMessage.text = "Emailadres is ongeldig!"
                errorMessage.isHidden = false
                return
            }
            if TextFieldWachtwoord.text == "" {
                TextFieldWachtwoord.layer.borderColor = UIColor.red.cgColor
                TextFieldWachtwoord.layer.borderWidth = 1.0
                return
            }

        }

        errorMessage.backgroundColor = UIColor.systemOrange
        errorMessage.text = "Verbinden met server..."
        errorMessage.isHidden = false
        dataController.loginUser(email: "user@example.com", password: "string", completion: {
            (bool) in
            if bool {
                self.errorMessage.backgroundColor = UIColor.systemGreen
                self.errorMessage.text = "Aangemeld!"
                self.dismiss(animated: true, completion: nil)
                self.dataController.getLoggedInUser { (gbr) in
                    self.dataController.gebruiker = gbr
                }
            } else {
                self.errorMessage.backgroundColor = UIColor.systemRed
                self.errorMessage.text = "Er liep iets fout!"
            }
        })



    }

}

