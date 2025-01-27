//
//  APIService.swift
//  WeatherApp
//
//  Created by Umair on 27/01/2025.
//


import Foundation

protocol APIService {
    func fetchForecast(forCity city: String, completion: @escaping (Result<ForecastData, Error>) -> Void)
    func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<CurrentData, Error>) -> Void)
    func fetchAirPollution(forCity city: String, completion: @escaping (Result<PollutionData, Error>) -> Void)
}