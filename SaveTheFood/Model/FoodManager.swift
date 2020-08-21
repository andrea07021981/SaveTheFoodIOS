//
//  FoodManager.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-16.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FoodManagerDelegate {
    func didUpdateFoods(_ foodManager: FoodManager, foods: [FoodModel])
    func didDeleteFood(_ food: FoodModel)
    func didSavedFood()
    func didFailWithError(error: Error)
}

class FoodManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: FoodManagerDelegate?
    
    //MARK: Manipulate local data
    
    func loadLocalfood() {
        //Load from db
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            // TODO check delete not working
//            let food = Food(context: self.context)
//            food.id = 1
//            food.name = "Pasta"
//            food.url = "https://spoonacular.com/productImages/481652-312x231.jpg"
            try saveFood()
            let foods = try context.fetch(request).map({ food -> FoodModel in
                FoodModel(foodId: food.id, foodName: food.name, foodUrl: food.url)
            })
            delegate?.didUpdateFoods(self, foods: foods)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func saveFood() throws {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
            throw error
        }
    }
    
    func saveFood(foodModel: FoodModel) {
        let food = Food(context: self.context)
        do {
            food.id = foodModel.foodId
            food.name = foodModel.foodName
            food.url = foodModel.foodUrl
            try saveFood()
            delegate?.didSavedFood()
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
    
    func deleteFood(_ food: FoodModel) {
        do {
            let request: NSFetchRequest<Food> = Food.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", food.foodId)
            let dbFood = try context.fetch(request)
            
            context.delete(dbFood[0])
            try context.save()
            delegate?.didDeleteFood(food)
        } catch {
            print("Error saving category \(error)")
        }
    }
}
