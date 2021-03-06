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
        
        //submitZipCode(submit_zip_code)
        
        // Setting up the mechanism using UserDefaults
        // Learned gritty details from https://developer.apple.com/documentation/foundation/userdefaults
        if !UserDefaults().bool(forKey: "setting_up")
        {
            UserDefaults().set(true, forKey: "setting_up")
            UserDefaults().set(0, forKey: "counting_task")
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
        
        guard let entry_task = storyboard?.instantiateViewController(withIdentifier: "enter_task") as? TaskEntryViewController else
        {
            return
        }
        
        entry_task.title = "New Task"
        entry_task.update =
        {
            self.updateTask()
        }
    
        
        navigationController?.pushViewController(entry_task, animated: true)
    }
    
    @IBAction func submitZipCodeBtn (sender: UIButton)
    {
        if (zip_code!.text != nil)
        {
            UserDefaults().set(zip_code!.text, forKey: "user_zip_code")
            
            let alert = UIAlertController(title: "Alert", message: "Zip Code Saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
