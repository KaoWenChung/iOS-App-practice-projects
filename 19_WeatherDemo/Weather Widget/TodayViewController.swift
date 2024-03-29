//
//  TodayViewController.swift
//  Weather Widget
//
//  Created by wyn on 2020/5/15.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherInfoKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    var defaults = UserDefaults(suiteName: "group.com.wyn.weatherappdemo")!
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    private var city = "Paris"
    private var country = "France"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cityLabel.text = "\(city), \(country)"
        
        // Get weather service to get weather data
        WeatherService.sharedWeatherService().getCurrentWeather(location: city) { (data) -> () in
            OperationQueue.main.addOperation({ () -> Void in
                if let weatherData = data {
                    self.weatherLabel.text = weatherData.weather.capitalized
                    self.temperatureLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                }
            })
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        // Get position from default
        if let currentCity = defaults.value(forKey: "city") as? String, let currentCountry = defaults.value(forKey: "country") as? String {
            
            city = currentCity
            country = currentCountry
        }
        
        cityLabel.text = "\(city), \(country)"
        
        WeatherService.sharedWeatherService().getCurrentWeather(location: city) { (data) -> () in
            guard let weatherData = data else {
                completionHandler(NCUpdateResult.noData)
                return
            }
            
            print(weatherData.weather)
            print(weatherData.temperature)
            
            OperationQueue.main.addOperation({ () -> Void in
                self.weatherLabel.text = weatherData.weather.capitalized
                self.temperatureLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
            })
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    
}
