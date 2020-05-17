//
//  TaskEntryViewController.swift
//  ToDoList
//
//  Created by Kevin on 5/14/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class TaskEntryViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var text_field: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        text_field.becomeFirstResponder()
        text_field.delegate = self
    }

    // Passing a reference to another view controller.
    // Gotten from https://www.youtube.com/watch?v=uKQjJb-KSwU
    // Also chapter 32 from book.
    var update: (() -> Void)?
    
    func recordTextInput(_text_field: UITextField)
    {
        saveInputTask()
    
    }
    
    func dateHandler(sender: UIDatePicker)
    {
        let time_formatter = DateFormatter()
        
        time_formatter.timeStyle = .long
        print (time_formatter.string(from: sender.date))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //saveInputTask()
        text_field.resignFirstResponder()
        
        return true
    }
    
    @IBAction func saveInputTask()
    {
        guard let text = text_field.text, !text.isEmpty else
        {
            return
        }
        
        //let task_date = data_picker.date
        
        guard let count = UserDefaults().value(forKey: "counting_task") as? Int else
        {
            return
        }
        
        let new_count = count + 1
        
        UserDefaults().set(new_count, forKey: "counting_task")
        UserDefaults().set(text, forKey: "task_value_\(new_count)")
        //UserDefaults().set(task_date, forKey: "task_date_\(new_count)")
        
        // Update table view via passing reference.
        update?()
        
        navigationController?.popViewController(animated: true)
        
//        let view_task = storyboard?.instantiateViewController(withIdentifier: "view_tasks") as! ViewToDoListScreen
//        navigationController?.pushViewController(view_task, animated: true)
    }
    
}
