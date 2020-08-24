//
//  FoodData.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-24.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import RealmSwift

class FoodData: Object {
    @objc dynamic var foodId: Int32 = 0
    @objc dynamic var foodName: String?
    @objc dynamic var foodUrl: String?
}
