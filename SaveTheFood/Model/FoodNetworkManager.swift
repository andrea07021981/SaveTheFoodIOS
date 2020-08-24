//
//  FoodNetworkManager.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-17.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol FoodNetworkManagerDelegate {
    func didRequestFoods(_ foodManager: FoodNetworkManager, foods: [FoodModel])
    func didFailWithError(error: Error)
}

class FoodNetworkManager {
    
    //https://api.spoonacular.com/food/products/search?apiKey=dc03ecff1b4e4630b92c6cf4d7412449&query=meat
    let url = K.base_url + "food/products/search?"
    
    var delegate: FoodNetworkManagerDelegate?
    
    //MARK: Manipulate network data
    func fetchFood(param: String) {
        let query = "\(url)apiKey=\(K.api_key)&query=\(param.trimmingCharacters(in: .whitespacesAndNewlines))"
        performRequest(with: query)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                } else {
                    if let safeData = data {
                        let foods = self.parseJSON(safeData)
                        self.delegate?.didRequestFoods(self, foods: foods)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ foodData: Data) -> [FoodModel] {
        let decoder = JSONDecoder()
        var foods = [FoodModel]()
        do {
            let decodedData = try decoder.decode(FoodNetworkData.self, from: foodData)
            let products = decodedData.products
            
            for product in products {
                foods.append(FoodModel(foodId: product.id, foodName: product.title, foodUrl: product.image))
            }
            return foods
        } catch {
            delegate?.didFailWithError(error: error)
            return foods
        }
    }
}
