//
//  CheckBox.swift
//  Shop List HW14
//
//  Created by admin2 on 24.06.2021.
//

import UIKit

class CheckBox: UIButton {

    //State images
    private let checkedImage = UIImage(named: "isChecked")
    private let uncheckedImage = UIImage(named: "isNotChecked")
    
    //State bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
    }
    
    @objc func didClickButton(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
