//
//  DetailedListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 24.06.2021.
//

import UIKit
import RealmSwift

class DetailedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emtpyListGreetingStackView: UIStackView!
    
    
    //var indexPath: IndexPath!
    var shoppingList: ShoppingList!
    var purchases: List<Purchase>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = shoppingList.name
        if purchases!.count != 0 {
            switchVisibility()
        }
        
        let floatingButton = floatingAddUIButton()
        view.addSubview(floatingButton)
    }
    
    private func switchVisibility() {
        tableView.isHidden = !tableView.isHidden
        emtpyListGreetingStackView.isHidden = !emtpyListGreetingStackView.isHidden
    }
}

extension DetailedListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        purchases?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath) as! PurchaseTableViewCell
        let purchase = purchases?[indexPath.row]
        
        cell.purcheseNameLabel.text = purchase? .name
        cell.purchaseAmountLabel.text = "\(String(describing: purchase?.amount)) \(purchase?.measurement ?? "")"
        
        return cell
    }
}
