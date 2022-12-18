//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Varun Bagga on 18/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error :Error)
}
