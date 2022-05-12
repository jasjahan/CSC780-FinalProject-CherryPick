//
//  FruitViewController.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/4/22.
//

import UIKit
import FirebaseAuth

class FruitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var pickfruit : [Fruit] = []
    var unpickfruit : [Fruit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickfruit = getFruit(picked: true)
        unpickfruit = getFruit(picked: false)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "In Your Basket"
        } else{
            return "Ready to be Picked"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pickfruit.count
        }else{
            return unpickfruit.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var frutika : Fruit
        if indexPath.section == 0{
            frutika = pickfruit[indexPath.row]
        } else{
            frutika = unpickfruit[indexPath.row]
        }
        cell.textLabel?.text = frutika.name
        if let imagename = frutika.imageName {
            cell.imageView?.image = UIImage(named:imagename)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            pickfruit.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            } catch {
            print("already logged out")
            }
        navigationController?.popToRootViewController(animated: true)
    }
}
