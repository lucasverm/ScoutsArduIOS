//
//  HistoryViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 10/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var wieleke: UIActivityIndicatorView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableview: UITableView!
    var selectedWinkelwagen: Winkelwagen!
    var dataController = DataController.shared
    var textViewData: [Winkelwagen] = []


    @IBAction func refresh(_ sender: Any) {
        self.indicatorVisible(true)
        if segmentedControl.selectedSegmentIndex == 0 {
            dataController.GetWinkelwagensOfGebruiker { (ww) in
                self.dataController.myHistory = (ww)
                self.textViewData = (ww)
                self.indicatorVisible(false)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            dataController.GetWinkelwagensOfAllUsers { (ww) in
                self.dataController.stamHistory = ww
                self.textViewData = ww
                self.indicatorVisible(false)
            }
        }
    }
    
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

    @IBAction func veranderingTablad(_ sender: UISegmentedControl) {
        self.indicatorVisible(true)
        if sender.selectedSegmentIndex == 0 {
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
        } else if sender.selectedSegmentIndex == 1 {
            if(!self.dataController.stamHistoryOpgehaald) {
                dataController.GetWinkelwagensOfAllUsers { (ww) in
                    self.dataController.stamHistory = ww
                    self.textViewData = ww
                    self.dataController.stamHistoryOpgehaald = true
                    self.indicatorVisible(false)
                }
            } else {
                self.textViewData = self.dataController.stamHistory
                self.indicatorVisible(false)
            }
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textViewData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Winkelwagen", for: indexPath) as! HistoryTableViewCell
        let item = textViewData[indexPath.row]
        cell.textLabel?.text = item.getFormattedDate() + " (" + item.getFormattedTime() + ")"
        cell.detailTextLabel?.text = "€" + String(item.totaalPrijs())
        cell.item = item
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
        vc.titleString = "History"

    }

}
