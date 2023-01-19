//
//  WeatherServiceManager.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import Foundation
import Combine

enum WeatherServiceError : Error {
    case url(URLError)
    case urlRequest
    case decode
}



protocol WeatherServiceManagerProtocol{
    
    func fetchWeatherDetails(searchCity: String?) -> AnyPublisher<WeatherModel, Error>
  
}

final class WeatherServiceManager : WeatherServiceManagerProtocol {
    
    func fetchWeatherDetails(searchCity: String?) -> AnyPublisher<WeatherModel, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<WeatherModel, Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(searchCity: searchCity ?? "") else {
                promise(.failure(WeatherServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                  let weatherData =  try JSONDecoder().decode(WeatherModel.self, from: data)
                    promise(.success(weatherData))
                }catch {
                    promise(.failure(WeatherServiceError.decode))
                }
            }
        }
        
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(searchCity: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/forecast.json?"
        components.queryItems = [
            URLQueryItem(name: "key", value: "522db6a157a748e2996212343221502"),
            URLQueryItem(name: "q", value: searchCity),
            URLQueryItem(name: "days", value: "7"),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")
        ]
        
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}
