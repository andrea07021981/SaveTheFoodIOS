//
//  HomeViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-07-10.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import SwipeCellKit

class HomeViewController : UIViewController {
    
    @IBOutlet var foodsTableView: UITableView!
    
    var foods: Results<FoodData>?
    var foodManager = FoodManager()
    override func viewWillAppear(_ animated: Bool) {
        foodManager.delegate = self
        
        foodsTableView.dataSource = self
        foodsTableView.delegate = self
        foodsTableView.register(UINib(nibName: K.foodCell, bundle: nil), forCellReuseIdentifier: "Cell")
        
        foodManager.loadLocalfood()
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addFoodButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.homeToSearchFoodSegue, sender: self)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "LogOut", message: "Would you like to log out?", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            DispatchQueue.main.async() {
                do {
                    try Auth.auth().signOut()
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print(error)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel))
        self.present(alert, animated: true)
    }
    
}

//MARK: Food delegate
extension HomeViewController : FoodManagerDelegate{
    func didSavedFood() {
        //Nothing
    }
    
    func didDeleteFood(_ food: FoodData) {
        
    }
    
    func didUpdateFoods(_ foodManager: FoodManager, foods: Results<FoodData>?) {
        self.foods = foods
        foodsTableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: Tableview data management
extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foods?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodCell
        if let food = foods?[indexPath.row] {
            cell.foodNameLabel.text = food.foodName
            if let url = URL(string: food.foodUrl!) {
                load(url: url, cell: cell)
            }
        } else {
            cell.textLabel?.text = "No Food Added"
        }
        cell.delegate = self
        return cell
    }
   
    func load(url: URL, cell: FoodCell) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.foodImageView.image = image
                    }
                }
            }
        }
    }
}

extension HomeViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //Check orientation of swipe
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            guard let food = self.foods?[indexPath.row] else {
                fatalError("No food found")
            }
            self.foodManager.deleteFood(food)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

extension HomeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: K.homeToDetailFoodSegue, sender: nil)
        performSegue(withIdentifier: "test", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Commented for test view
//        let destination = segue.destination as! FoodDetailViewController
//        if let index = foodsTableView.indexPathForSelectedRow {
//            destination.selectedFood = foods?[index.row]
//        }
    }
}
