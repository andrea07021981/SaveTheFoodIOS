//
//  FoodManager.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-16.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol FoodManagerDelegate {
    func didUpdateFoods(_ foodManager: FoodManager, foods: Results<FoodData>?)
    func didDeleteFood(_ food: FoodData)
    func didSavedFood()
    func didFailWithError(error: Error)
}

class FoodManager {
        
    var delegate: FoodManagerDelegate?
    let realm = try! Realm()
    
    //MARK: Manipulate local data
    
    func loadLocalfood() {
        //Load from db
        do {
            let foods = try realm.objects(FoodData.self)
            delegate?.didUpdateFoods(self, foods: foods)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func saveFood(food: FoodData) throws {
        do {
            try realm.write {
                realm.add(food)
            }
        } catch {
            print("Error saving category \(error)")
            throw error
        }
    }
    
    func saveFood(foodModel: FoodModel) {
        let food = FoodData()
        do {
            food.foodId = foodModel.foodId
            food.foodName = foodModel.foodName
            food.foodUrl = foodModel.foodUrl
            try saveFood(food: food)
            delegate?.didSavedFood()
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func deleteFood(_ food: FoodData) {
        do {
            try realm.write {
                realm.delete(food)
            }
            delegate?.didDeleteFood(food)
        } catch {
            print("Error saving category \(error)")
            delegate?.didFailWithError(error: error)
        }
    }
}
