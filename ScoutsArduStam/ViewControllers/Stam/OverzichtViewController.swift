//
//  OverzichtViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class OverzichtViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var buttonTotaal: UIButton!
    var dataController = DataController.shared
    var winkelwagen: Winkelwagen!

    override func viewDidLoad() {
        super.viewDidLoad()
        var som: Float = 0
        for itemAantal in winkelwagen.items {
            som += (itemAantal.item!.prijs * Float(itemAantal.aantal))
        }
        let afgerond = (som * 1000).rounded() / 1000
        let totaal = "Totaal: € " + String(afgerond)
        if som == 0 {
            buttonTotaal.isEnabled = false
            buttonTotaal.backgroundColor = UIColor.systemGray4

        }
        buttonTotaal.setTitle(totaal, for: .normal)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winkelwagen.items.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverzichtItem", for: indexPath) as! OverichtTableViewCell

        let itemAantal = winkelwagen.items[indexPath.row]
        cell.itemAantal = itemAantal
        cell.labelNaam.text = itemAantal.item!.naam
    cell.labelAantal.text = String(itemAantal.aantal)
        let som = Float(itemAantal.aantal) * itemAantal.item!.prijs
        let afgerond = (som * 1000).rounded() / 1000
        cell.labelPrijs.text = "€ " + String(afgerond)
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! Sante_ViewController
        vc.navigationItem.hidesBackButton = true
        self.winkelwagen.gebruiker = self.dataController.gebruiker
        vc.winkelwagen = self.winkelwagen
        vc.bekijken = false
        self.dataController.gebruiker.winkelwagens.append(self.winkelwagen)
    }


}
