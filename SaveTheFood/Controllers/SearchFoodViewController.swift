//
//  SearchFoodViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-17.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

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
        tableViewFoods.register(UINib(nibName: K.foodCell, bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Nav controller doesn't exist")
        }
        if let customColor = UIColor(named: "Primary") {
            navBar.backgroundColor = customColor
            navBar.tintColor = ContrastColorOf(customColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(customColor, returnFlat: true)]
        }
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
        
        //Ask for permissions
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//
//        }
        
        //Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Info food"
        content.body = "Food Added"

        // Create the notification trigger
        let date = Date().addingTimeInterval(1)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // Create the request
        let uuiString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuiString, content: content, trigger: trigger)
        
        // Register the request
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodCell
        
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
