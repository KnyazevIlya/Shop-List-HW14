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

protocol dataReloadProtocol {
    func reloadData()
}


class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - outlets
    @IBOutlet var tableView: UITableView!
    
    private var shoppingLists: Results<ShoppingList>!
    
    //MARK: - life cycle
    //Show navbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarVisibility(visible: true, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor(hex: "3CCE64")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarVisibility(visible: true, animated: true)
        
        shoppingLists = StorageManager.realm.objects(ShoppingList.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let floatingButton = floatingAddUIButton(self, zoomOnTouch: true)
        floatingButton.addTarget(self, action: #selector(performAddListSegue), for: .touchUpInside)
        
        view.addSubview(floatingButton)
    }
    
//MARK: - methods
    @objc func performAddListSegue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.performSegue(withIdentifier: "addList", sender: nil)
        })
    }
    
//MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedList" {
            if let indexPath = sender as? IndexPath {
                let vc = segue.destination as! DetailedListViewController
                vc.shoppingList = shoppingLists[indexPath.row]
                vc.purchases = shoppingLists[indexPath.row].purchases
                vc.shoppingListDelegate = self
            }
        }
    }
}


//MARK: - table view data source
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
        
        cell.nameTextField.text = shoppingList.name
        
        cell.boughtRatioLabel.text = "\(shoppingList.load)/\(shoppingList.maxLoad)"
        cell.purchasesProgressView.progress = shoppingList.maxLoad == 0 ? 0 : Float(shoppingList.load) / Float(shoppingList.maxLoad)
        cell.shoppingList = shoppingList
        cell.delegate = tableView
        cell.cellIndex = indexPath
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailedList", sender: indexPath)
    }
    
}

//MARK: - navigationBarVisibilityProtocol
extension ShoppingListViewController: navigationBarVisibilityProtocol {
    
    func setNavigationBarVisibility(visible state: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(!state, animated: animated)
    }
}

//MARK: - dataReloadProtocol
extension ShoppingListViewController: dataReloadProtocol {
    func reloadData() {
        shoppingLists = StorageManager.realm.objects(ShoppingList.self)
        tableView.reloadData()
    }
}
