//
//  MockAPIService.swift
//  WeatherApp
//
//  Created by Umair on 28/01/2025.
//

import Foundation
@testable import WeatherApp

class MockAPIService: APIService {
    var shouldFailAirPollution = false
    var shouldFailForecast = false
    var shouldFailCurrentWeather = false

    func fetchForecast(forCity city: String, completion: @escaping (Result<ForecastData, Error>) -> Void) {
        if shouldFailForecast {
            completion(.failure(NSError(domain: "ForecastError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Forecast API failed"])))
        } else {
            let mockForecastData = ForecastData(
                cod: "200",
                message: 0,
                cnt: 40,
                list: [
                    ForecastData.List(
                        dt: 1672531200,
                        main: ForecastData.List.Main(temp: 15.5, feels_like: 14.0, temp_min: 12.0, temp_max: 18.0, pressure: 1015, sea_level: 1015, grnd_level: 1000, humidity: 82, temp_kf: 0.0),
                        weather: [ForecastData.List.Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                        clouds: ForecastData.List.Clouds(all: 0),
                        wind: ForecastData.List.Wind(speed: 3.1, deg: 250, gust: nil),
                        visibility: 10000,
                        pop: 0.0,
                        sys: ForecastData.List.Sys(pod: "d"),
                        dt_txt: "2023-12-31 15:00:00",
                        rain: nil,
                        snow: nil
                    )
                ],
                city: ForecastData.City(
                    id: 5128581,
                    name: "New York",
                    coord: ForecastData.City.Coord(lat: 40.7128, lon: -74.0060),
                    country: "US",
                    population: 8175133,
                    timezone: -18000,
                    sunrise: 1672492800,
                    sunset: 1672533600
                )
            )
            completion(.success(mockForecastData))
        }
    }

    func fetchCurrentWeather(forCity city: String, completion: @escaping (Result<CurrentData, Error>) -> Void) {
        if shouldFailCurrentWeather {
            completion(.failure(NSError(domain: "CurrentWeatherError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current weather API failed"])))
        } else {
            let mockCurrentWeatherData = CurrentData(
                coord: CurrentData.Coord(lon: -74.0060, lat: 40.7128),
                weather: [CurrentData.Weather(id: 800, main: "Clear", desc: "clear sky", icon: "01d")],
                base: "stations",
                main: CurrentData.Main(temp: 15.5, feels_like: 14.0, temp_min: 12.0, temp_max: 18.0, pressure: 1015, humidity: 82, sea_level: 1015, grnd_level: 1000),
                visibility: 10000,
                wind: CurrentData.Wind(speed: 3.1, deg: 250),
                clouds: CurrentData.Clouds(all: 0),
                dt: 1672531200,
                sys: CurrentData.Sys(type: 1, id: 1414, country: "US", sunrise: 1672492800, sunset: 1672533600),
                timezone: -18000,
                id: 5128581,
                name: "New York",
                cod: 200,
                rain: nil,
                snow: nil
            )
            completion(.success(mockCurrentWeatherData))
        }
    }

    func fetchAirPollution(forCity city: String, completion: @escaping (Result<PollutionData, Error>) -> Void) {
        if shouldFailAirPollution {
            completion(.failure(NSError(domain: "AirPollutionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Air pollution API failed"])))
        } else {
            let mockPollutionData = PollutionData(
                list: [
                    PollutionEntry(
                        main: MainPollution(aqi: 2),
                        components: PollutionComponents(
                            co: 373.84,
                            no: 4.41,
                            no2: 23.65,
                            o3: 60.8,
                            so2: 8.11,
                            pm2_5: 16.38,
                            pm10: 20.08,
                            nh3: 1.22
                        )
                    )
                ]
            )
            completion(.success(mockPollutionData))
        }
    }
}
