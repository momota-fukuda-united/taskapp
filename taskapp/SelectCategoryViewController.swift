//
//  SelectCategoryViewController.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/08.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import RealmSwift
import UIKit

class SelectCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    @IBOutlet private var selectTableView: UITableView!
    
    private let categories: Results<CategoryModel> = try! Realm().objects(CategoryModel.self)
    var selectedCategory: CategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.selectTableView.delegate = self
        self.selectTableView.dataSource = self
        
        self.navigationController?.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.selectTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = self.categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = self.categories[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let decideCategory = viewController as? DecideCategoryProtocol
        if self.selectedCategory != nil {
            decideCategory?.decide(category: self.selectedCategory!)
        }
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
