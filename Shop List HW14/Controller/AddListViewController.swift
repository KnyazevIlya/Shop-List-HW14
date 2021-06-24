//
//  AddListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 21.06.2021.
//

import UIKit

class AddListViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var listNameTextfield: UITextField!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        listNameTextfield.delegate = self
        listNameTextfield.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - private methods
    private func createShoppingList() {
        let listName: String = listNameTextfield.text == nil ? "New list" : listNameTextfield.text!
        let newShoppingList = ShoppingList(value: [listName, 0, 0, Date(), false])
        
        DispatchQueue.main.async {
            StorageManager.saveShoppingList([newShoppingList])
            self.performSegue(withIdentifier: "backToShoppingLists", sender: nil)
        }
    }
    
    //MARK: - text field behaviour
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createShoppingList()
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - IBActions
    @IBAction func didTapCreateList(_ sender: Any) {
        createShoppingList()
    }
}
