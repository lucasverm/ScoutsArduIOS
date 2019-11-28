//
//  ViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 06/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var facebookLogin: UIButton!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var TextFieldEmail: UITextField!
    @IBOutlet var TextFieldWachtwoord: UITextField!
    @IBOutlet var ButtonLogin: UIButton!
    @IBOutlet var ButtonRegistreer: UIButton!
    var dataController = DataController.shared

    @IBOutlet var faTest: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        TextFieldEmail.delegate = self
        TextFieldWachtwoord.delegate = self
        errorMessage.isHidden = true
        self.navigationItem.hidesBackButton = true
        ButtonRegistreer.layer.borderWidth = 1.0
        ButtonRegistreer.layer.cornerRadius = 5.0
        ButtonRegistreer.layer.borderColor = UIColor(red:0.37, green:0.04, blue:0.17, alpha:1.0).cgColor
        ButtonLogin.layer.cornerRadius = 5.0
        facebookLogin.layer.cornerRadius = 5.0
        TextFieldWachtwoord.layer.borderWidth = 1.0
        TextFieldWachtwoord.layer.borderColor = UIColor.systemGray.cgColor
        TextFieldEmail.layer.borderWidth = 1.0
        TextFieldEmail.layer.borderColor = UIColor.systemGray.cgColor
        // Obtain all constraints for the button:
        let layoutConstraintsArr = facebookLogin.constraints
        // Iterate over array and test constraints until we find the correct one:
        for lc in layoutConstraintsArr { // or attribute is NSLayoutAttributeHeight etc.
            if (lc.constant == 28) {
                // Then disable it...
                lc.isActive = false
                break
            }
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        if dataController.userIsAuthenticated {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func facebookLoginButtonClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.errorMessage.backgroundColor = UIColor.systemOrange
            self.errorMessage.text = "Inloggen met facebook..."
            self.errorMessage.isHidden = false
        }
        self.dataController.loginManager.logIn(
            permissions: [.email, .publicProfile, .userFriends],
            viewController: self
        ) { result in
            switch result {
            case .cancelled:
                DispatchQueue.main.async {
                    self.errorMessage.backgroundColor = UIColor.systemRed
                    self.errorMessage.text = "U canncelde het aanmelden met facebook..."
                }

            case .failed:
                DispatchQueue.main.async {
                    self.errorMessage.backgroundColor = UIColor.systemRed
                    self.errorMessage.text = "Er liep iets fout tijdens het aanmelden met facebook!"
                }

            case .success:
                GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email"]).start(completionHandler: { (connection, result, error) in

                    guard let Info = result as? [String: Any] else { return }

                    if let email = Info["email"] as? String
                    {
                        DispatchQueue.main.async {
                            self.errorMessage.text = "Ingelogd met facebook! Verbinden met server..."
                        }
                        let voornaam = Info["first_name"] as? String
                        let achternaam = Info["last_name"] as? String
                        self.dataController.loginFacebookUser(email: email, voornaam: voornaam!, achternaam: achternaam!) { variable in
                            if (variable) {
                                self.dataController.userIsAuthenticated = true
                                DispatchQueue.main.async {
                                    self.errorMessage.backgroundColor = UIColor.systemGreen
                                    self.errorMessage.text = "Aangemeld!"
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.errorMessage.backgroundColor = UIColor.systemRed
                                    self.errorMessage.text = "Er liep iets fout!"
                                }
                            }
                        }
                    }

                })
            }
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

