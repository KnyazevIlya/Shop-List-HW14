//
//  ShoppingListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 17.06.2021.
//

import UIKit
import RealmSwift

protocol navigationBarVisibilityProtocol {
    func setNavigationBarVisibility(visible state: Bool, animated: Bool)
}


class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: - outlets
    @IBOutlet var tableView: UITableView!
    
    private var shoppingLists: Results<ShoppingList>!
    
    //MARK: - life cycle
    //Show navbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisibility(visible: true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingLists = StorageManager.realm.objects(ShoppingList.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        /*tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self*/
        
        let floatingButton = floatingAddUIButton(self)
        floatingButton.addTarget(self, action: #selector(performAddListSegue), for: .touchUpInside)
        
        view.addSubview(floatingButton)
    }
    
    @objc func performAddListSegue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.performSegue(withIdentifier: "addList", sender: nil)
            
            /*try! StorageManager.realm.write {
                StorageManager.realm.deleteAll()
            }
            
            let shoppingList = ShoppingList(value: ["MyList", 10, 17, Date(), false])
            
            let bread = Purchase(value: ["bread", 3, Date(), false, "loave"])
            shoppingList.purchases.append(bread)
            
            DispatchQueue.main.async {
                StorageManager.saveShoppingList([shoppingList])
            }*/
        })
    }
}

//MARK: - table view delegate
extension ShoppingListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        
        if indexPath.row != 0 {
            cell.topConstraint.constant = 0
        }
        
        let shoppingList = shoppingLists[indexPath.row]
        
        cell.nameLabel.text = shoppingList.name
        cell.boughtRatioLabel.text = shoppingList.maxLoad == 0 ? "empty" : "\(shoppingList.load)/\(shoppingList.maxLoad)"
        cell.purchasesProgressView.progress = shoppingList.maxLoad == 0 ? 0 : Float(shoppingList.load) / Float(shoppingList.maxLoad)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

//MARK: - navigationBarVisibilityProtocol extension
extension ShoppingListViewController: navigationBarVisibilityProtocol {
    
    func setNavigationBarVisibility(visible state: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(!state, animated: animated)
    }
}


