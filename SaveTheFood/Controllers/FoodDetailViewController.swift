//
//  FoodDetailViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-24.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

class FoodDetailViewController : UIViewController {
    
    var selectedFood: FoodData? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func loadData() {
        
    }
    @IBAction func testButton(_ sender: UIButton) {
        sender.removeFromSuperview()
    }
}
