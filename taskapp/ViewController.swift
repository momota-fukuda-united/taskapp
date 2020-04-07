//
//  ViewController.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/06.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import RealmSwift
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let selectTaskSegueId = "selectTask"
    
    @IBOutlet private var taskTabkeView: UITableView!
    private let realm = try! Realm()
    private var tasks = try! Realm().objects(TaskModel.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.taskTabkeView.dataSource = self
        self.taskTabkeView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let taskDetailViewController = segue.destination as! TaskDetailViewController
        
        taskDetailViewController.task = self.getOrCreateShownTask(showTaskDetailSegue: segue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.taskTabkeView.reloadData()
    }
    
    private func getOrCreateShownTask(showTaskDetailSegue: UIStoryboardSegue) -> TaskModel {
        if showTaskDetailSegue.identifier == self.selectTaskSegueId {
            let indexPath = self.taskTabkeView.indexPathForSelectedRow
            return self.tasks[indexPath!.row]
        }
        
        let newTask = TaskModel()
        
        let allTasks = self.realm.objects(TaskModel.self)
        if allTasks.count != 0 {
            newTask.id = allTasks.max(ofProperty: "id")! + 1
        }
        
        return newTask
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.taskTabkeView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateText = dateFormatter.string(from: task.date)
        cell.detailTextLabel?.text = dateText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.selectTaskSegueId, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        try! self.realm.write {
            self.realm.delete(self.tasks[indexPath.row])
            self.taskTabkeView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
