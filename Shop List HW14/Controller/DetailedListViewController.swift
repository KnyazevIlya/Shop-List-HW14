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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shoppingList.name
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configurateInitialVisibility()
        configurateFloatingButton()
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
        if let purchase = purchases?[indexPath.row] {
            cell.purcheseNameLabel.text = purchase.name
            cell.purchaseAmountLabel.text = "\(purchase.amount) \(purchase.measurement)"
            cell.tableView = tableView.self
            cell.shoppingList = shoppingList
            cell.indexInShoppingList = shoppingList.purchases.index(of: purchase)
            cell.shoppingListIndex = shoppingListIndex
            cell.shoppingListViewDelegate = shoppingListDelegate
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - handle insertion
extension DetailedListViewController {
    private func handleInsertion(insertion: Int) {
        let objects = StorageManager.realm.objects(ShoppingList.self)
        guard let index = shoppingListIndex else { return }
        shoppingList = objects[index]
        purchases = shoppingList.purchases
        
        if insertion == 0 {
            switchGreetingVisibility(show: false)
        }
        tableView.insertRows(at: [IndexPath(row: insertion - 1, section: 0)], with: .left)
        
        shoppingListDelegate?.reloadData()
    }
}
