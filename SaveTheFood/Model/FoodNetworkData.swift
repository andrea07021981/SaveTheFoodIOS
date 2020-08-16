//
//  Food.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-16.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation

struct FoodNetworkData : Codable{
    
    var id: Int = 0

    let title: String

    let description: String?

    let imgUrl: String
    
    let likes: Double?

    let price: Double?
    
    let calories: Double?

    let fat: String?

    let proteins: String?

    let carbs: String?

    let ingredientList: String?

    let servingSize: String?
}
