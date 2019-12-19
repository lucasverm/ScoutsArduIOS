//
//  WachtwoordVergetenViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 13/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class WachtwoordVergetenViewController: UIViewController {


    @IBOutlet var verzenden: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var error: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        error.isHidden = true;
        verzenden.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    func validateEmail(email: String) -> Bool {
           let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
           return emailPredicate.evaluate(with: email)
       }

    
    @IBAction func emailVerzenden(_ sender: Any) {
        error.isHidden = true
        if textField.text == ""{
            error.text = "vul je emailadres in!"
            error.isHidden = false
            return
        }
        
        if !validateEmail(email: textField.text!) {
            error.text = "Emailadres is ongeldig!"
            error.isHidden = false
            return
        }
        error.text = "Email verzonden: check je mailbox!"
        error.backgroundColor = UIColor.systemGreen
        error.isHidden = false
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
