//
//  addPurchaseUITableView.swift
//  Shop List HW14
//
//  Created by admin2 on 27.06.2021.
//

import UIKit

class addPurchaseUIViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var measurementTextField: UITextField!
    
    var shoppingList: ShoppingList?
    var purchasesTableView: UITableView?
    var shoppingListDelegate: dataReloadProtocol?
    
    override func viewDidLoad() {
        configurateTextFieldsDelegate()
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: - private methods
    private func configurateTextFieldsDelegate() {
        nameTextField.delegate = self
        amountTextField.delegate = self
        measurementTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchTextField(textField: textField)
        return textField.resignFirstResponder()
    }
    
    private func switchTextField(textField: UITextField) {
        switch textField {
        case nameTextField:
            amountTextField.becomeFirstResponder()
        case amountTextField:
            measurementTextField.becomeFirstResponder()
        case measurementTextField:
            view.endEditing(true)
            savePurchase()
            hideAddMenu()
        default:
            return
        }
    }
    
    private func hideAddMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - text fields behaviour
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - db managing
    private func savePurchase() {
        guard let shoppingList = shoppingList,
              let purchasesTableView = purchasesTableView,
              let shoppingListDelegate = shoppingListDelegate else { return }
        
        let name = nameTextField.text ?? "New purchase"
        let amount = Int(amountTextField.text ?? "") ?? 1
        let measurement = measurementTextField.text ?? ""
        
        let purchase = Purchase(value: [name, amount, Date(), false, measurement])
        
        DispatchQueue.main.async {
            StorageManager.updateList(shoppingList, property: .purchase, value: purchase)
            StorageManager.updateList(shoppingList, property: .maxLoad, value: shoppingList.maxLoad + 1)
            purchasesTableView.reloadData()
            shoppingListDelegate.reloadData()
        }
    }
}

