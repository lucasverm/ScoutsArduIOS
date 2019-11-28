//
//  StamCollectionViewController.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

private let reuseIdentifier = "Cell"

class StamCollectionViewController: UICollectionViewController {

    var dataController = DataController.shared
    var gebruiker = DataController.shared.gebruiker
    var array = [
        MenuItem(label: "enen drinken?!", afbeelding: "cheers.jpg", type: MenuEnum.enenDrinken),
        MenuItem(label: "Portefeuille", afbeelding: "money.jpg", type: MenuEnum.portefeuille),
        MenuItem(label: "History", afbeelding: "history.jpg", type: MenuEnum.history)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let itemSize = UIScreen.main.bounds.width / 2 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView.collectionViewLayout = layout
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if !dataController.userIsAuthenticated {
            self.performSegue(withIdentifier: "login", sender: self)
        }

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.destination is EnenDrinkenTableViewController {
            _ = segue.destination as! EnenDrinkenTableViewController
        } else if segue.destination is HistoryViewController {
            _ = segue.destination as! HistoryViewController
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return array.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItem", for: indexPath) as! MenuCollectionViewCell
        let menuItem = array[indexPath.row]
        cell.menuItemLabel.text = menuItem.label
        cell.menuItemImage.image = UIImage(named: menuItem.afbeelding)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = array[indexPath.row]
        if (menuItem.type == MenuEnum.enenDrinken) {
            performSegue(withIdentifier: "enenDrinken", sender: self)
        } else if(menuItem.type == MenuEnum.portefeuille) {
            performSegue(withIdentifier: "portefeuille", sender: self)
        } else if(menuItem.type == MenuEnum.history) {
            performSegue(withIdentifier: "history", sender: self)
        }
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
