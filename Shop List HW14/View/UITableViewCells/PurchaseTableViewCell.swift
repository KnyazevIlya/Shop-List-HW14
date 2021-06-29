//
//  PurchaseTableViewCell.swift
//  Shop List HW14
//
//  Created by admin2 on 24.06.2021.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet var checkBox: CheckBox!
    @IBOutlet var purcheseNameLabel: UILabel!
    @IBOutlet var purchaseAmountLabel: UILabel!
    
    var tableView: UITableView?
    var shoppingList: ShoppingList?
    var indexInShoppingList: Int?
    //var shoppingListIndex: Int?
    var shoppingListViewDelegate: dataReloadProtocol?

    override func awakeFromNib() {
        selectionStyle = .none
        checkBox.addTarget(self, action: #selector(handleCheckBoxStateChange), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundIfCompleted()
    }
    
    private func setBackgroundIfCompleted() {
        guard let shoppingList = shoppingList, let indexInShoppingList = indexInShoppingList else { return }
        let purchase = shoppingList.purchases[indexInShoppingList]
        
        checkBox.isChecked = purchase.isCompleted
        if purchase.isCompleted {
            backgroundColor = UIColor(hex: "EBFAEF")
            purcheseNameLabel.textColor = .systemGray
            purchaseAmountLabel.textColor = .systemGray
        } else {
            backgroundColor = .white
            purcheseNameLabel.textColor = .black
            purchaseAmountLabel.textColor = .black
        }
    }
    
    @objc func handleCheckBoxStateChange() {
        guard let shoppingList = shoppingList,
              let indexInShoppingList = indexInShoppingList,
              let tableView = tableView,
              let shoppingListViewDelegate = shoppingListViewDelegate else { return }
        
        DispatchQueue.main.async {
            StorageManager.updatePurchase(inList: shoppingList, atIndex: indexInShoppingList, property: .isCompleted, value: self.checkBox.isChecked)
            
            let newLoad: Int
            if self.checkBox.isChecked {
                newLoad = shoppingList.load + 1
            } else {
                newLoad = shoppingList.load - 1
            }
            StorageManager.updateList(shoppingList, property: .load, value: newLoad)
            
            //let objects = StorageManager.realm.objects(ShoppingList.self)
            //self.shoppingList = objects[shoppingListIndex]
            self.setBackgroundIfCompleted()
            
            tableView.reloadData()
            shoppingListViewDelegate.reloadData()
        }
    }
    
    
}
