//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Umair on 27/01/2025.
//

import Foundation

final class WeatherViewModel: ObservableObject {
    @Published var forecastData: ForecastData?
    @Published var currentWeather: CurrentData?
    @Published var airPollution: PollutionData?
    @Published var errorMessage: String?
    
    private let apiService: APIService
    
    init(apiService: APIService = WeatherService.shared) {
        self.apiService = apiService
    }
    
    func fetchWeather(forCity city: String) {

        apiService.fetchForecast(forCity: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecastData):
                    self?.forecastData = forecastData
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.forecastData = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        apiService.fetchCurrentWeather(forCity: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currentWeather):
                    self?.currentWeather = currentWeather
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.currentWeather = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        apiService.fetchAirPollution(forCity: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let airPollution):
                    self?.airPollution = airPollution
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.airPollution = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
