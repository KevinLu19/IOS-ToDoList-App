//
//  DisplayTaskViewController.swift
//  ToDoList
//
//  Created by Kevin on 5/14/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class DisplayTaskViewController: UIViewController
{
    public var deletion_handler: (() -> Void)?
    
    @IBOutlet var task_label: UILabel!
    @IBOutlet var show_task_date: UILabel!
    
    var submitted_task: String?
    
    static let date_formatter: DateFormatter =
    {
        let date_format = DateFormatter()
        date_format.dateStyle = .medium
        
        return date_format
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        task_label.text = submitted_task
        
        //show_task_date.text = Self.date_formatter.string(from: task_item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete Task", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask()
    {
        // To DO:
        // let newCount = count - 1
        // UserDefaults().setValue(newCount, forkey: "count")
        // UserDefaults().setValue(nil, forkey: "task_(currentPosition)")
        // When removing a task, we need to shift all numbers below it by 1 sicne we will have an empty number.
        
        deletion_handler?()
        navigationController?.popToRootViewController(animated: true)
    }
}
