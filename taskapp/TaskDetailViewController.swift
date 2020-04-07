//
//  CreateTaskViewController.swift
//  taskapp
//
//  Created by 福田 桃太 on 2020/04/06.
//  Copyright © 2020 momota-fukuda. All rights reserved.
//

import RealmSwift
import UIKit
import UserNotifications

class TaskDetailViewController: UIViewController {
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private var contentsTextView: UITextView!
    @IBOutlet private var datePicker: UIDatePicker!
    
    var task: TaskModel!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.titleTextField.text = self.task.title
        self.categoryTextField.text = self.task.category
        self.contentsTextView.text = self.task.contents
        self.datePicker.date = self.task.date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! self.realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categoryTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: .modified)
        }
        
        self.setNotification(task: self.task)
        
        super.viewWillDisappear(animated)
    }
    
    private func setNotification(task: TaskModel) {
        let content = UNMutableNotificationContent()
        
        content.title = task.title.isEmpty ? "(タイトルなし)" : task.title
        content.body = task.contents.isEmpty ? "(内容なし)" : task.contents
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: { error in
            print(error ?? "ローカル通知登録 OK")
        })
        
        notificationCenter.getPendingNotificationRequests(completionHandler: { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        })
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
