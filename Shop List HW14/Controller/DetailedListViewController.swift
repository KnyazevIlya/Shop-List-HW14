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
    var purchases: List<Purchase>?
    var shoppingListIndex: Int?
    var shoppingListDelegate: dataReloadProtocol?
    
    private let floatingButton = floatingAddUIButton()
    private var uncheckedPurchases: Results<Purchase>!
    private var checkedPurchses: Results<Purchase>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shoppingList.name
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configurateInitialVisibility()
        configurateFloatingButton()
        filterData()
    }
    
    private func filterData() {
        checkedPurchses = shoppingList.purchases.filter("isCompleted = true")
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
        if purchases!.count == 0 {
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

//MARK: - tableView delegate
extension DetailedListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if purchases?.count ?? 0 > 0 && self.tableView.isHidden {
            switchGreetingVisibility(show: false)
        }
        
        return purchases?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as! PurchaseTableViewCell
        let purchase = indexPath.row > uncheckedPurchases.count - 1 ? checkedPurchses[indexPath.row - uncheckedPurchases.count] : uncheckedPurchases[indexPath.row]
        
        cell.purcheseNameLabel.text = purchase.name
        cell.purchaseAmountLabel.text = "\(purchase.amount) \(purchase.measurement)"
        cell.tableView = tableView.self
        cell.shoppingList = shoppingList
        cell.indexInShoppingList = shoppingList.purchases.index(of: purchase)
        cell.shoppingListIndex = shoppingListIndex
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
                
                let purchase = indexPath.row > uncheckedPurchases.count - 1 ? checkedPurchses[indexPath.row - uncheckedPurchases.count] : uncheckedPurchases[indexPath.row]
                let loadChange = purchase.isCompleted ? shoppingList.load - 1 : shoppingList.load
                
                StorageManager.deletePurchase(from: shoppingList, purchase: purchase)
                StorageManager.updateList(shoppingList, property: .maxLoad, value: self.shoppingList.maxLoad - 1)
                StorageManager.updateList(shoppingList, property: .load, value: loadChange)
                
                
                shoppingList = StorageManager.realm.objects(ShoppingList.self)[shoppingListIndex!]
                purchases = shoppingList.purchases
                
                tableView.reloadData()
                shoppingListDelegate!.reloadData()
                //tableView.deleteRows(at: , with: ) не работает, оно валится где-то(
            }
        }
        return action
    }
}
