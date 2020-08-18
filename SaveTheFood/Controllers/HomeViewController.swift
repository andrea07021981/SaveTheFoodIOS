//
//  HomeViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-07-10.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

class HomeViewController : UIViewController {
    
    @IBOutlet var foodsTableView: UITableView!
    
    var foods = [FoodModel]()
    var foodManager = FoodManager()
    override func viewWillAppear(_ animated: Bool) {
        foodManager.delegate = self
        
        foodsTableView.dataSource = self
        foodsTableView.delegate = self
        foodsTableView.register(UINib(nibName: K.foodCell, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
        
        foodManager.loadLocalfood()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addFoodButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.homeToSearchFoodSegue, sender: self)
    }
}

//MARK: Food delegate
extension HomeViewController : FoodManagerDelegate{
    func didSavedFood() {
        //Nothing
    }
    
    func didDeleteFood(_ food: FoodModel) {
        if let index = foods.firstIndex(where: { foodItem -> Bool in
            food.foodId == foodItem.foodId
        }) {
            self.foods.remove(at: index)
        }
        
        self.foodsTableView.reloadData()
    }
    
    func didUpdateFoods(_ foodManager: FoodManager, foods: [FoodModel]) {
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
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            foodManager.deleteFood(foods[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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

extension HomeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
