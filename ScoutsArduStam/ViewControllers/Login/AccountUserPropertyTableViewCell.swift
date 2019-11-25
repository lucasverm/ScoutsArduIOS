//
//  AccountUserPropertyTableViewCell.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 11/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import UIKit

class AccountUserPropertyTableViewCell: UITableViewCell {

    @IBOutlet var TextFieldInput: UITextField!
    @IBOutlet var LabelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
