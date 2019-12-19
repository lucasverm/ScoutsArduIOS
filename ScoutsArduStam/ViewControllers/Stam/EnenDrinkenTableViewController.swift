//
//  EnenDrinkenTableViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class EnenDrinkenTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var wieleke: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var winkelwagenItemsAantal: [WinkelwagenItemAantal] = []
    var dataController = DataController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        wieleke.startAnimating()
        dataController.getWinkelwagenItems(completion: {
            (items) in
            self.winkelwagenItemsAantal.append(contentsOf: items)
            self.UpdateUI()
        })

    }

    func UpdateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.wieleke.stopAnimating()
            self.wieleke.isHidden = true
            self.tableView.isHidden = false

        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return winkelwagenItemsAantal.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WinkelwagenItem", for: indexPath) as! WinkelwagenItemTableViewCell

        let itemAantal = winkelwagenItemsAantal[indexPath.row]
        cell.itemAantal = itemAantal
        cell.textLabel?.text = itemAantal.item!.naam
        cell.labelAantal.text = String(itemAantal.aantal)
        let som = Float(itemAantal.aantal) * itemAantal.item!.prijs
        let afgerond = (som * 1000).rounded() / 1000
        cell.labelTotaal.text = "€ " + String(afgerond)
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let winkelwagen = Winkelwagen()

        for item in winkelwagenItemsAantal {
            if item.aantal != 0 {
                winkelwagen.items.append(item)
            }
        }
        let vc = segue.destination as! OverzichtViewController
        vc.winkelwagen = winkelwagen
    }


}
