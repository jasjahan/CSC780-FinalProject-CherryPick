//
//  FruitViewController.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/4/22.
//

import UIKit
import FirebaseAuth

class FruitViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
                    
        navigationController?.popToRootViewController(animated: true)
    }
    

}
