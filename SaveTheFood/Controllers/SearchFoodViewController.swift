//
//  SearchFoodViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-17.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

class SearchFoodViewController : UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableViewFoods: UITableView!
    
    var foodNetworkData = [FoodModel]()
    let foodManager = FoodNetworkManager()
    var foods = [FoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

// MARK: - Search bar methids
extension SearchFoodViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let filter = searchBar.text {
            self.foodManager.fetchFood(param: filter)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
