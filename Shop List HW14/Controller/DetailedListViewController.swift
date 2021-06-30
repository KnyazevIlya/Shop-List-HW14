//
//  DetailedListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 24.06.2021.
//

import UIKit
import RealmSwift
import Spring

class DetailedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyListGreetingStackView: UIStackView!
    
    var shoppingList: ShoppingList!
    var purchases: List<Purchase>!
    var shoppingListDelegate: dataReloadProtocol!
    
    private let floatingButton = floatingAddUIButton()
    private var uncheckedPurchases: Results<Purchase>!
    private var checkedPurchases: Results<Purchase>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shoppingList.name
        purchases = shoppingList.purchases
        tableView.dataSource = self
        tableView.delegate = self
        
        configurateInitialVisibility()
        configurateFloatingButton()
        
        filterData()
        
    }
    
    //MARK: - private methods
    private func filterData() {
        checkedPurchases = shoppingList.purchases.filter("isCompleted = true")
        uncheckedPurchases = shoppingList.purchases.filter("isCompleted = false")
    }
    
    //MARK: - initial styling
    private func configurateTableView() {
        tableView.backgroundColor = UIColor(hex: "EBFAEF")
    }
    
    private func configurateFloatingButton() {
        floatingButton.addTarget(self, action: #selector(toAddPurchaseMenu), for: .touchUpInside)
        view.addSubview(floatingButton)
    }
    
    private func configurateInitialVisibility() {
        emptyListGreetingStackView.isHidden = true
        if purchases.count == 0 {
            switchGreetingVisibility(show: true)
        }
    }
    
    private func switchGreetingVisibility(show: Bool) {
        tableView.isHidden = show
        emptyListGreetingStackView.isHidden = !show
    }
    
    //MARK: - navigation
    @objc func toAddPurchaseMenu() {
        performSegue(withIdentifier: "addPurchaseMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPurchaseMenu" {
            let vc = segue.destination as! addPurchaseUIViewController
            vc.shoppingList = shoppingList
            vc.purchasesTableView = tableView.self
            vc.shoppingListDelegate = shoppingListDelegate
        }
    }
}

//MARK: - tableView data source
extension DetailedListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if purchases.count > 0 && self.tableView.isHidden {
            switchGreetingVisibility(show: false)
        }
        
        return section == 0 ? uncheckedPurchases.count : checkedPurchases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return uncheckedPurchases.count == 0 ? nil : "To buy"
        } else {
            return checkedPurchases.count == 0 ? nil : "Baught"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as! PurchaseTableViewCell
        let purchase = indexPath.section == 0 ? uncheckedPurchases[indexPath.row] : checkedPurchases[indexPath.row]
        
        cell.purcheseNameLabel.text = purchase.name
        cell.purchaseAmountLabel.text = "\(purchase.amount) \(purchase.measurement)"
        cell.tableView = tableView.self
        cell.shoppingList = shoppingList
        cell.indexInShoppingList = shoppingList.purchases.index(of: purchase)
        cell.shoppingListViewDelegate = shoppingListDelegate

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - contextual actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
    
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (_, _, _) in
            DispatchQueue.main.async {
                
                let purchase: Purchase
                if indexPath.section == 0 {
                    purchase = uncheckedPurchases[indexPath.row]
                } else {
                    purchase = checkedPurchases[indexPath.row]
                }
                let loadChange = purchase.isCompleted ? shoppingList.load - 1 : shoppingList.load
                
                StorageManager.deletePurchase(from: shoppingList, purchase: purchase)
                StorageManager.updateList(shoppingList, property: .maxLoad, value: self.shoppingList.maxLoad - 1)
                StorageManager.updateList(shoppingList, property: .load, value: loadChange)
                
                filterData()
                tableView.reloadData()
                shoppingListDelegate!.reloadData()
            }
        }
        return action
    }
}
