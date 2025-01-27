//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Umair on 27/01/2025.
//

import Foundation
import SwiftUI

final class WeatherService: APIService {
    static let shared = WeatherService()
    private let apiKey = "4f9f242e2f6fcd9825d4521a43e4aa45"
    
    @AppStorage("units") private var units: String = "metric"
    
    private func makeURL(for endpoint: String) -> String {
        return "https://api.openweathermap.org/data/2.5/\(endpoint)&appid=\(apiKey)&units=\(units)"
    }
    
    func fetchForecast(forCity city: String, completion: @escaping (Result<ForecastData, Error>) -> Void) {
        let urlString = makeURL(for: "forecast?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        fetchData(urlString: urlString, completion: completion)
    }
    
    func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<CurrentData, Error>) -> Void) {
        let urlString = makeURL(for: "weather?q=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        fetchData(urlString: urlString, completion: completion)
    }
    
    func fetchAirPollution(forCity city: String, completion: @escaping (Result<PollutionData, Error>) -> Void) {
        fetchCurrentWeather(forCity: city) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                let latitude = currentWeather.coord.lat
                let longitude = currentWeather.coord.lon
                let urlString = self?.makeURL(for: "air_pollution?lat=\(latitude)&lon=\(longitude)") ?? ""
                self?.fetchData(urlString: urlString, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        print("URL: \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Response Data: \(rawResponse)")
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("Decoded Response: \(decodedData)")
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
