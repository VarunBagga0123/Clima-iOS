//
//  WeatherManager.swift
//  Clima
//
//  Created by Varun Bagga on 18/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2497d02db1633fa319c48c0279e0ba07&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){                                      
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        
        //1. Create URl
        if let url = URL(string: urlString){
            //2. Create a URlSESSION
            let  session = URLSession(configuration: .default)
            //3. Give URLsession a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if  let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    //    func handle(data:Data?,response:URLResponse?,error: Error?){
    //
    //        if error != nil{
    //            print(error!)
    //            return
    //        }
    //
    //        if let safeData = data{
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
          let decodedData =   try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
           
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   
    
}
