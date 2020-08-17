//
//  Food.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-16.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation

struct FoodNetworkData : Codable{
    var number: Int
    var offset: Int
    var products: [NetworkProduct]
    var totalProducts: Int
    var type: String
}

struct NetworkProduct : Codable {
    var id: Int32
    var image: String?
    var imageType: String?
    var title: String?
}
