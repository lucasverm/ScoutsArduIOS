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
        errorMessageIsHidden(bool: true)
        for item in textVelden{
            item.layer.borderWidth = 1.0
            item.layer.borderColor = UIColor.systemGray.cgColor
        }

    }

    @IBAction func ButtonBack(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }


    @IBAction func Registreer(_ sender: Any) {
       /*TextFieldEmail.layer.borderWidth = 0
        TextFieldPassword.layer.borderWidth = 0
        TextFieldPasswordConfirmation.layer.borderWidth = 0
        TextFieldVoornaam.layer.borderWidth = 0
        TextFieldAchternaam.layer.borderWidth = 0
        TextFieldTelefoon.layer.borderWidth = 0
        
        errorMessageIsHidden(bool: true)
        let doChecks = false

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
            

        }*/
        errorMessageColor(color: UIColor.systemOrange)
        errorMessageText(text: "Account creeëren...")
        errorMessageIsHidden(bool: false)
        dataController.registerUser(email:TextFieldEmail.text!, password:TextFieldPassword.text!, voornaam: TextFieldVoornaam.text!, achternaam: TextFieldAchternaam.text!, passwordConfirmation: TextFieldPasswordConfirmation.text!, telNr: TextFieldTelefoon.text!, completion: {
            (bool) in
            if bool {
                self.errorMessageText(text: "Welkom!")
                self.errorMessageColor(color: UIColor.green)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.errorMessageColor(color: UIColor.systemRed)
                self.errorMessageText(text: "Er liep iets fout!")
            }
        })
         
    }
    
    func errorMessageText(text: String) {
        DispatchQueue.main.async {
            self.errorMessage.text = text
        }
    }
    
    func errorMessageColor(color: UIColor) {
        DispatchQueue.main.async {
            self.errorMessage.backgroundColor = color
        }
    }
    
    func errorMessageIsHidden(bool: Bool) {
        DispatchQueue.main.async {
            self.errorMessage.isHidden = bool
        }
    }
    
    
}
