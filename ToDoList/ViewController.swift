//
//  ViewController.swift
//  ToDoList
//
//  Created by Kevin on 4/30/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var zip_code: UITextField!
    
    private var task = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Task"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setting up the mechanism using UserDefaults
        // Learned gritty details from https://developer.apple.com/documentation/foundation/userdefaults
        if !UserDefaults().bool(forKey: "setting_up")
        {
            UserDefaults().set(true, forKey: "setting_up")
            UserDefaults().set(0, forKey: "counting_task")
            UserDefaults().set(0, forKey: "counting_task_dates")
        }
        
        updateTask()
    }
    
    func updateTask()
        {
            task.removeAll()
            
            guard let task_count = UserDefaults().value(forKey: "counting_task") as? Int else
            {
                return
            }
            
            for i in 0..<task_count
            {
                if let enter_task = UserDefaults().value(forKey: "task_value_\(i + 1)") as? String
                {
                    task.append(enter_task)
                }
            }
            
            tableView.reloadData()
        }
        
        @IBAction func addTask()
        {
            //let entry_task = storyboard?.instantiateViewController(withIdentifier: "enter_task") as! TaskEntryViewController
            
    //        let entry_task_date = storyboard?.instantiateViewController(withIdentifier: "enter_task") as! TaskEntryViewController
            
            guard let entry_task = storyboard?.instantiateViewController(withIdentifier: "enter_task") as? TaskEntryViewController else
            {
                return
            }
            
            entry_task.title = "New Task"
            // Everytime user enters in a task, update the table view.
            entry_task.update =
            {
                self.updateTask()
            }
        
            
            navigationController?.pushViewController(entry_task, animated: true)
        }
        
            
    }

    extension ViewController: UITableViewDelegate
    {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            tableView.deselectRow(at: indexPath, animated: true)

            let entry_task = storyboard?.instantiateViewController(withIdentifier: "task_info") as! DisplayTaskViewController

            entry_task.title = "New Task"
            entry_task.submitted_task = task[indexPath.row]
            
            navigationController?.pushViewController(entry_task, animated: true)
        }
    }


    extension ViewController: UITableViewDataSource
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return (task.count)
        }
        
        // Using template over and over inorder to get instance of the cell so we can supply each cell extra information.
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "main_cell", for: indexPath)
            
            cell.textLabel?.text = task[indexPath.row]
            
            return (cell)
        }

}

