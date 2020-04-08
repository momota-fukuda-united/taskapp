//
//  CreateCategoryViewController.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/08.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import UIKit
import RealmSwift

class CreateCategoryViewController: UIViewController {
    @IBOutlet private var categoryTextField: UITextField!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onTapCreateButton(_ sender: UIButton) {
        try! self.realm.write {
            let category = CategoryModel()
            category.name = self.categoryTextField.text!
            let allCategory = self.realm.objects(CategoryModel.self)
            if allCategory.count > 0 {
                category.id = allCategory.max(ofProperty: "id")! + 1
            }
            self.realm.add(category)
        }
        
        self.categoryTextField.text = ""
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
