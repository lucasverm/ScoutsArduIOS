//
//  WinkelwagenItemTableViewCell.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class WinkelwagenItemTableViewCell: UITableViewCell {

    @IBOutlet var labelTotaal: UILabel!
    @IBOutlet var labelAantal: UILabel!
    @IBOutlet var stepperAantal: UIStepper!
    var itemAantal: WinkelwagenItemAantal! {
        didSet {
            stepperAantal.value = Double(itemAantal.aantal)
        }
    }

    func updateCell() {
        labelAantal.text = String(Int(itemAantal.aantal))
        let som = Float(itemAantal.aantal) * itemAantal.item!.prijs
        let afgerond = (som * 1000).rounded() / 1000
        labelTotaal.text = "€ " + String(afgerond)

    }

    @IBAction func StepperAction(_ sender: UIStepper) {
        itemAantal.aantal = Int(sender.value)
        updateCell()
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
