//
//  OverichtTableViewCell.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 07/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class OverichtTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAantal: UILabel!
    @IBOutlet weak var labelNaam: UILabel!
    @IBOutlet weak var labelPrijs: UILabel!
    var item: WinkelwagenItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
