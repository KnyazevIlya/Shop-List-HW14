//
//  ShoppingListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 17.06.2021.
//

import UIKit
import Spring

class ShoppingListViewController: UIViewController {
    
    //Show navbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(floatingAddUIButton())
    }
}

/*//MARK: - table view delegate
extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}*/
