//
//  RegisterViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 06/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet var ButtonRegistreer: UIButton!
    var dataController = DataController.shared
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var TextFieldPasswordConfirmation: UITextField!
    @IBOutlet var TextFieldPassword: UITextField!
    @IBOutlet var TextFieldEmail: UITextField!
    @IBOutlet var TextFieldTelefoon: UITextField!
    @IBOutlet var TextFieldAchternaam: UITextField!
    @IBOutlet var TextFieldVoornaam: UITextField!
    
    @IBOutlet var textVelden: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonRegistreer.layer.cornerRadius = 5.0
        errorMessage.isHidden = true
        for item in textVelden{
            item.layer.borderWidth = 1.0
            item.layer.borderColor = UIColor.systemGray.cgColor
        }

    }

    @IBAction func ButtonBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }


    @IBAction func Registreer(_ sender: Any) {
        TextFieldEmail.layer.borderWidth = 0
        TextFieldPassword.layer.borderWidth = 0
        TextFieldPasswordConfirmation.layer.borderWidth = 0
        TextFieldVoornaam.layer.borderWidth = 0
        TextFieldAchternaam.layer.borderWidth = 0
        TextFieldTelefoon.layer.borderWidth = 0
        
        errorMessage.isHidden = true
        let doChecks = true

        if doChecks {
            
            if TextFieldVoornaam.text == "" {
                TextFieldVoornaam.layer.borderColor = UIColor.red.cgColor
                TextFieldVoornaam.layer.borderWidth = 1.0
                return
            }
            
            if TextFieldAchternaam.text == "" {
                TextFieldAchternaam.layer.borderColor = UIColor.red.cgColor
                TextFieldAchternaam.layer.borderWidth = 1.0
                return
            }

            
            if TextFieldTelefoon.text == "" {
                TextFieldTelefoon.layer.borderColor = UIColor.red.cgColor
                TextFieldTelefoon.layer.borderWidth = 1.0
                return
            }
            
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
            
            if TextFieldPassword.text == "" {
                TextFieldPassword.layer.borderColor = UIColor.red.cgColor
                TextFieldPassword.layer.borderWidth = 1.0
                return
            }
            
            if TextFieldPasswordConfirmation.text == "" {
                TextFieldPasswordConfirmation.layer.borderColor = UIColor.red.cgColor
                TextFieldPasswordConfirmation.layer.borderWidth = 1.0
                return
            }
            
            if TextFieldPasswordConfirmation.text != TextFieldPassword.text{
                TextFieldPassword.layer.borderColor = UIColor.red.cgColor
                TextFieldPassword.layer.borderWidth = 1.0
                TextFieldPasswordConfirmation.layer.borderColor = UIColor.red.cgColor
                TextFieldPasswordConfirmation.layer.borderWidth = 1.0
                errorMessage.text = "Wachtwoord en wachtwoord bevestiging komen niet overeen!"
                errorMessage.isHidden = false
                return
            }
            

        }

        errorMessage.backgroundColor = UIColor.systemOrange
        errorMessage.text = "Account creeëren..."
        errorMessage.isHidden = false
        dataController.registerUser(email:TextFieldEmail.text!, password:TextFieldPassword.text!, voornaam: TextFieldVoornaam.text!, achternaam: TextFieldAchternaam.text!, passwordConfirmation: TextFieldPasswordConfirmation.text!, completion: {
            (bool) in
            if bool {
                self.errorMessage.backgroundColor = UIColor.systemGreen
                self.errorMessage.text = "Aangemaakt!"
                self.dismiss(animated: true, completion: nil)
            } else {
                self.errorMessage.backgroundColor = UIColor.systemRed
                self.errorMessage.text = "Er liep iets fout!"
            }
        })
    }
}
