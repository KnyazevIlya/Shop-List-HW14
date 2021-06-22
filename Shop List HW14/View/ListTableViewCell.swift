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
    @IBOutlet var subview: UIView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subview.layer.cornerRadius = 5
        
        //shadow style
        subview.layer.shadowOffset = CGSize(width: 0, height: 2)
        subview.layer.shadowOpacity = 0.25
        subview.layer.shadowRadius = 6
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            subview.backgroundColor = UIColor(hex: "E4F8EA")
            subview.layer.shadowOpacity = 0.5
        } else {
            subview.backgroundColor = .white
            subview.layer.shadowOpacity = 0.25
        }
    }
    
}
