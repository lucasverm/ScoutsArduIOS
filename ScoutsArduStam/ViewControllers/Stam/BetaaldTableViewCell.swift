//
//  BetaaldTableViewCell.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 10/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class BetaaldTableViewCell: UITableViewCell {

    @IBOutlet var labelNaam: UILabel!
    @IBOutlet var labelAantal: UILabel!
    var itemAantal: WinkelwagenItemAantal!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
