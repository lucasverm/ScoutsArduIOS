//
//  AccountViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 11/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit
class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var wieleke: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var dataController: DataController = DataController.shared
    var gebruiker: Gebruiker?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorVisible(true)
        dataController.getLoggedInUser(completion: {
            (gbr) in
            self.gebruiker = gbr
            self.indicatorVisible(false)
        })
    }

    func indicatorVisible(_ varia: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = varia
            if varia {
                self.wieleke.startAnimating()
            } else {
                self.wieleke.stopAnimating()
            }
            self.wieleke.isHidden = !varia
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.gebruiker == nil {
            return 0
        }
        return 6
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {

        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountNaam", for: indexPath) as! AccountNameTableViewCell
            cell.detailTextLabel?.text = gebruiker?.email
            cell.textLabel?.text = (gebruiker?.voornaam.capitalized ?? "") + " " + (gebruiker?.achternaam.capitalized ?? "")
            cell.imageView?.image = UIImage(named: "user")

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProperty", for: indexPath) as! AccountUserPropertyTableViewCell
            cell.LabelText.text = "Voornaam"
            cell.TextFieldInput.text = gebruiker?.voornaam.capitalized
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProperty", for: indexPath) as! AccountUserPropertyTableViewCell
            cell.LabelText.text = "Achternaam"
            cell.TextFieldInput.text = gebruiker?.achternaam.capitalized
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProperty", for: indexPath) as! AccountUserPropertyTableViewCell
            cell.LabelText.text = "Telefoon nummer"
            cell.TextFieldInput.text = gebruiker?.telefoonNummer
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProperty", for: indexPath) as! AccountUserPropertyTableViewCell
            cell.LabelText.text = "Emailadres"
            cell.TextFieldInput.text = gebruiker?.email
            cell.TextFieldInput.isUserInteractionEnabled = false
            cell.TextFieldInput.textColor = UIColor.systemGray
            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "uitloggen", for: indexPath) as! AccountUitloggenTableViewCell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1...4:
            let cell = tableView.cellForRow(at: indexPath) as! AccountUserPropertyTableViewCell
            cell.TextFieldInput.becomeFirstResponder()
        case 5:
            dataController.gebruiker = nil
            dataController.bearerToken = ""
            dataController.userIsAuthenticated = false
            tabBarController?.selectedIndex = 0
            let secondVC = tabBarController!.viewControllers?[tabBarController!.selectedIndex] as! UINavigationController
            secondVC.popToRootViewController(animated: false)
        default:
            return
        }
    }


    @IBAction func save(_ sender: Any) {
        self.indicatorVisible(true)
        let cellsData = self.getAllCellsData()
        dataController.putGebruiker(voornaam: cellsData[0], achternaam: cellsData[1], telnr:
                cellsData[2]) { gelukt in
            if(gelukt) {
                self.gebruiker = self.dataController.gebruiker
                self.indicatorVisible(false)

        }

    }

}

func getAllCellsData() -> [String] {

    var cellsData = [String]()
    // assuming tableView is your self.tableView defined somewhere
    for i in 0...tableView.numberOfSections - 1
    {
        for j in 1...3
        {
            if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i) as IndexPath) {
                let dataCell = cell as! AccountUserPropertyTableViewCell
                cellsData.append(dataCell.TextFieldInput!.text!)
            }

        }
    }
    return cellsData
}

}
