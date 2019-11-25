//
//  SantéViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class Sante_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var labelUwBestelling: UILabel!
    @IBOutlet var textView: UITableView!
    @IBOutlet var wieleke: UIActivityIndicatorView!
    @IBOutlet var labelTijdstip: UILabel!
    @IBOutlet var labelDatum: UILabel!
    @IBOutlet var labelPrijs: UILabel!
    var dataController: DataController = DataController.shared
    var winkelwagen: Winkelwagen!
    var bekijken: Bool!
    var titleString: String = "Betaald, santé!"

    @IBOutlet var labelNaam: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorVisible(varia: true)
        if(!bekijken) {
            dataController.gebruiker.winkelwagens.append(self.winkelwagen)
            self.dataController.postWinkelwagen(winkelwagen: self.winkelwagen) { (res) in
                if (res) {
                    self.updateUi()
                    self.indicatorVisible(varia: !true)
                }
            }
        }else {
            self.updateUi()
            self.indicatorVisible(varia: !true)
        }

    }

    func indicatorVisible(varia: Bool) {
        DispatchQueue.main.async {
            self.labelPrijs.isHidden = varia
            self.labelNaam.isHidden = varia
            self.labelDatum.isHidden = varia
            self.labelTijdstip.isHidden = varia
            self.labelUwBestelling.isHidden = varia
            self.textView.isHidden = varia
            if varia {
                self.title = ""
                self.wieleke.startAnimating()
            } else {
                self.title = self.titleString
                self.wieleke.stopAnimating()
            }
            self.wieleke.isHidden = !varia
        }
    }

    func updateUi() {
        DispatchQueue.main.async {
            self.labelPrijs.text = "Prijs: €" + String(self.winkelwagen.totaalPrijs())
            self.labelNaam.text = "Naam: " + self.dataController.gebruiker.voornaam.capitalized + " " + self.dataController.gebruiker!.achternaam.capitalized
            self.labelDatum.text = "Datum: " + self.winkelwagen.getFormattedDate()
            self.labelTijdstip.text = "Tijdstip: " + self.winkelwagen.getFormattedTimeWithSeconds()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.winkelwagen == nil {
            return 0
        }
        return self.winkelwagen.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverzichtItem", for: indexPath) as! BetaaldTableViewCell
        let item = winkelwagen.items[indexPath.row]
        cell.backgroundColor = self.view.backgroundColor
        cell.item = item
        cell.labelAantal.text = String(item.aantal)
        cell.labelNaam.text = item.naam
        return cell
    }
}
