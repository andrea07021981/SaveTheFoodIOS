//
//  SearchFoodViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-17.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit
import RealmSwift

class SearchFoodViewController : UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableViewFoods: UITableView!
    
    var foodNetworkData = [FoodModel]()
    let foodNetworkManager = FoodNetworkManager()
    let foodManager = FoodManager()
    
    var foods = [FoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodNetworkManager.delegate = self
        foodManager.delegate = self
        searchBar.delegate = self
        tableViewFoods.dataSource = self
        tableViewFoods.delegate = self
        tableViewFoods.register(UINib(nibName: K.foodCell, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
    }
}

//MARK: Food delegate
extension SearchFoodViewController : FoodNetworkManagerDelegate {
    func didRequestFoods(_ foodManager: FoodNetworkManager, foods: [FoodModel]) {
        self.foods = foods
        DispatchQueue.main.async {
            self.tableViewFoods.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: Food local delegate
extension SearchFoodViewController : FoodManagerDelegate {
    func didUpdateFoods(_ foodManager: FoodManager, foods: Results<FoodData>?) {
        
    }
    
    func didDeleteFood(_ food: FoodData) {
        
    }
    
    func didSavedFood() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Search bar methids
extension SearchFoodViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let filter = searchBar.text {
            self.foodNetworkManager.fetchFood(param: filter)
        }
    }
}

//MARK: Tableview datasource
extension SearchFoodViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        
        cell.foodNameLabel.text = food.foodName
        if let url = URL(string: food.foodUrl!) {
            load(url: url, cell: cell)
        }
        
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

//MARK: Tableview delegate
extension SearchFoodViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "New Food", message: "Do you want to save the food?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            if let indexPath = tableView.indexPathForSelectedRow {
                self.foodManager.saveFood(foodModel: self.foods[indexPath.row])
            }
        }
        let actionCancell = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        //Prepare alert
        alert.addAction(action)
        alert.addAction(actionCancell)
        self.present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
