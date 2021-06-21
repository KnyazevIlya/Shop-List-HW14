//
//  ShoppingListViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 17.06.2021.
//

import UIKit
import Spring

class ShoppingListViewController: UIViewController {
    
    private let addButton: SpringButton = {
        let screenWidthPercent = UIScreen.main.bounds.width / 100
        let screenHightPercent = UIScreen.main.bounds.height / 100
        let highlitedColor = UIColor(displayP3Red: 255/255,
                                     green: 255/255,
                                     blue: 255/255,
                                     alpha: 128/255)
        
        let button = SpringButton(frame: CGRect(x: screenWidthPercent * 75,
                                                y: screenHightPercent * 75,
                                                width: screenWidthPercent * 20,
                                                height: screenWidthPercent * 20))
        
        button.backgroundColor = UIColor(displayP3Red: 52/255,
                                         green: 199/255,
                                         blue: 89/255,
                                         alpha: 255/255)
        
        //initial styling
        let fontSize = button.frame.width / 2
        button.layer.cornerRadius = button.frame.width / 2
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.contentEdgeInsets = UIEdgeInsets(top: -fontSize / 8, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(prt), for: .touchUpInside)
        
        //highlited styling
        button.setTitleColor(highlitedColor, for: .highlighted)
        
        return button
    }()
    
    //Show navbar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func prt() {
        print("tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
