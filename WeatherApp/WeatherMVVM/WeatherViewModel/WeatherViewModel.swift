//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import Foundation
import Combine


enum WeatherViewModelError: Error, Equatable {
    case fetchTeams
}

enum WeatherViewModelState {
    case loading
    case finishedLoading
    case error(WeatherViewModelError)
}

final class WeatherViewModel {
    
    enum Section { case  Forecastday}

    @Published private(set) var weatherModel: WeatherModel = WeatherModel(location: Location(name: "", region: "", country: "", lat: 0.0, lon: 0.0, tzID: "", localtimeEpoch: 0, localtime: ""),current: Current(lastUpdatedEpoch: 0, lastUpdated: "", tempC: 0, tempF: 0.0, isDay: 0,condition: Condition(text: "" ,icon: "",code: 0),windMph: 0.0,windKph: 0.0,windDegree: 0, windDir: "", pressureMB: 0, pressureIn: 0.0, precipMm: 0, precipIn: 0, humidity: 0, cloud: 0, feelslikeC: 0.0, feelslikeF: 0.0, visKM: 0, visMiles: 0, uv: 0, gustMph: 0.0, gustKph: 0 ), forecast: Forecast(forecastday: []))
    @Published private(set) var state: WeatherViewModelState = .loading
    
    
    private let serviceManager: WeatherServiceManagerProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(serviceManager: WeatherServiceManagerProtocol = WeatherServiceManager()) {
        self.serviceManager = serviceManager
    }

    func fetchWeatherData(forCity searchCity: String) {
        fetchWeather(searchFor: searchCity)
    }
}

extension WeatherViewModel {
    
    
    private func fetchWeather(searchFor searchCity: String ) {
        state = .loading
        
        let teamsCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.fetchTeams)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let teamsValueHandler: (WeatherModel) -> Void = { [weak self] teams in
            self?.weatherModel = teams
        }
        
        serviceManager
            .fetchWeatherDetails(searchCity: searchCity)
            .sink(receiveCompletion: teamsCompletionHandler, receiveValue: teamsValueHandler)
            .store(in: &bindings)
    }
}

