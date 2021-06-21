//
//  ListTableViewCell.swift
//  Shop List HW14
//
//  Created by admin2 on 21.06.2021.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var boughtRatioLabel: UILabel!
    @IBOutlet var purchasesProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
