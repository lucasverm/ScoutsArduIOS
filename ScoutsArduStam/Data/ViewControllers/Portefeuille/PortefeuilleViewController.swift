//
//  PortefeuilleViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 22/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class PortefeuilleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var wieleke: UIActivityIndicatorView!
    @IBOutlet var tableview: UITableView!
    
    var textViewData: [Winkelwagen] = []
    var selectedWinkelwagen: Winkelwagen!

    var dataController = DataController.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorVisible(true)
        if (!self.dataController.myHistoryOpgehaald) {
            dataController.GetWinkelwagensOfGebruiker { (ww) in
                self.dataController.myHistory = (ww)
                self.textViewData = (ww)
                self.indicatorVisible(false)
                self.dataController.myHistoryOpgehaald = true
            }
        } else {
            self.textViewData = self.dataController.myHistory
            self.indicatorVisible(false)
        }
    }


    @IBAction func refresh(_ sender: Any) {
        
        self.indicatorVisible(true)
        dataController.GetWinkelwagensOfGebruiker { (ww) in
            self.dataController.myHistory = (ww)
            self.textViewData = (ww)
            self.indicatorVisible(false)
        }
    }

    func indicatorVisible(_ varia: Bool) {
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.tableview.isHidden = varia
            if varia {
                self.wieleke.startAnimating()
            } else {
                self.wieleke.stopAnimating()
            }
            self.wieleke.isHidden = !varia
        }
    }


   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textViewData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portefeuille", for: indexPath) as! PortefeuilleTableViewCell
        let item = textViewData[indexPath.row]
        cell.textLabel?.text = item.getFormattedDate() + " (" + item.getFormattedTime() + ")"
        cell.detailTextLabel?.text = "€" + String(item.totaalPrijs())
        cell.item = item
        if cell.item.betaald {
            cell.backgroundColor = UIColor.systemGreen
        } else {
            cell.backgroundColor = UIColor.systemRed
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedWinkelwagen = textViewData[indexPath.row]
        performSegue(withIdentifier: "sante", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! Sante_ViewController
        vc.winkelwagen = selectedWinkelwagen
        vc.bekijken = true
        if selectedWinkelwagen.betaald {
            vc.view.backgroundColor = UIColor.systemGreen
            vc.textView.backgroundColor = UIColor.systemGreen
        } else {
            vc.view.backgroundColor = UIColor.systemRed
            vc.textView.backgroundColor = UIColor.systemRed  
        }
        vc.titleString = "Portefeuille Item"

    }


}
