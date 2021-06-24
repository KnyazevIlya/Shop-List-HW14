//
//  ListTableViewCell.swift
//  Shop List HW14
//
//  Created by admin2 on 21.06.2021.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var boughtRatioLabel: UILabel!
    @IBOutlet var purchasesProgressView: UIProgressView!
    @IBOutlet var subview: UIView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var ellipsesButton: UIButton!
    
    var shoppingList: ShoppingList?
    var delegate: UITableView?
    var cellIndex: IndexPath?

//MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        nameTextField.isUserInteractionEnabled = false
        
        //subview style
        subview.layer.cornerRadius = 5
        
        //shadow style
        subview.layer.shadowOffset = CGSize(width: 0, height: 2)
        subview.layer.shadowOpacity = 0.25
        subview.layer.shadowRadius = 6
        configureButton(ellipsesButton)
    }
    
//MARK: - state styling
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if (highlighted) {
            subview.backgroundColor = UIColor(hex: "E4F8EA")
            subview.layer.shadowOpacity = 0.5
        } else {
            subview.backgroundColor = .white
            subview.layer.shadowOpacity = 0.25
        }
    }
    
//MARK: - private methods
    private func updateListName() {
        //TODO: - InputValidationManager
        let newName = nameTextField.text == "" ? "Renamed list" : nameTextField.text
        StorageManager.updateList(shoppingList!, property: .name, value: newName as Any)
        delegate?.reloadData()
    }
    
//MARK: - context ellipses menu
    private func configureButton(_ button: UIButton) {
        let rename = UIAction(title: "Rename") { _ in
            self.renameListAction()
            print("rename tapped")
        }
        
        let delete = UIAction(title: "Delete") { _ in
            print("delete tapped")
            self.deleteListAction()
        }
        
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(title: "", children: [rename, delete])
    }
    
    private func deleteListAction() {
        StorageManager.deleteShoppingList([shoppingList!])
        delegate?.deleteRows(at: [cellIndex!], with: .left)
    }
    
    private func renameListAction() {
        nameTextField.isUserInteractionEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
}


//MARK: - text field behaviour
extension ListTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        
        updateListName()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.isUserInteractionEnabled = false
        nameTextField.endEditing(true)
    }
}
