//
//  TaskEntryViewController.swift
//  ToDoList
//
//  Created by Kevin on 5/14/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit
import Foundation

class TaskEntryViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var task_time_picker: UIDatePicker!
    @IBOutlet var text_field: UITextField!
    
    @IBOutlet weak var tempt_lablel: UILabel!
    @IBOutlet weak var weather_description_label: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        text_field.becomeFirstResponder()
        text_field.delegate = self
        
        guard let user_zip = UserDefaults().value(forKey: "user_zip_code") as? String else { return }
        
        let full_weather_url = "http://api.openweathermap.org/data/2.5/weather?zip=\(user_zip),us&units=imperial&appid=<API KEY>"
        
        guard let url = URL(string: full_weather_url) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                    
                    guard let weather_info = json["weather"] as? [[String: Any]] else { return }
                    
                    guard let weather_main = json["main"] as? [String: Any] else { return }
                    
                    let tempt = Int(weather_main["temp"] as? Double ?? 0)
                    let weather_description = (weather_info.first?["description"] as? String)?.capitalizeFirstLetterOfDescription()
                    
                    DispatchQueue.main.async
                    {
                        self.setWeather(weather: weather_info.first?["main"] as? String, weather_description: weather_description, temp: tempt)
                    }
                }
                catch
                {
                    print ("Something went wrong!")
                }
            }
        }
        
        task.resume()
    }
    
    func setWeather(weather: String?, weather_description: String?, temp: Int)
    {
        tempt_lablel.text = "\(temp)°"
        weather_description_label.text = weather_description ?? "..."
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
        
        guard let task_date_count = UserDefaults().value(forKey: "counting_task_dates") as? Int else { return }
        
        let new_count = count + 1
        
        UserDefaults().set(new_count, forKey: "counting_task")
        UserDefaults().set(text, forKey: "task_value_\(new_count)")
        UserDefaults().set(task_date_count, forKey: "task_date_\(new_count)")
        
        // Update table view via passing reference.
        update?()
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension String
{
    func capitalizeFirstLetterOfDescription () -> String
    {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
