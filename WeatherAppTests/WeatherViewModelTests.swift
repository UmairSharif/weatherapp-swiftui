//
//  WeatherViewModelTests.swift
//  WeatherApp
//
//  Created by Umair on 28/01/2025.
//


import XCTest
@testable import WeatherApp

final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        
        let expectation = self.expectation(description: "Weather data fetched successfully")
        
        viewModel.fetchWeather(forCity: "London")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.viewModel.forecastData, "Forecast data should not be nil on success")
            XCTAssertNotNil(self.viewModel.currentWeather, "Current weather should not be nil on success")
            XCTAssertNotNil(self.viewModel.airPollution, "Air pollution data should not be nil on success")
            XCTAssertNil(self.viewModel.errorMessage, "Error message should be nil on success")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

    func testFetchWeatherFailure() {
        
        let expectation = self.expectation(description: "Weather data fetch failed")
        
        viewModel.fetchWeather(forCity: "InvalidCityName")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNil(self.viewModel.forecastData, "Forecast data should be nil on error")
            XCTAssertNil(self.viewModel.currentWeather, "Current weather should be nil on error")
            XCTAssertNil(self.viewModel.airPollution, "Air pollution data should be nil on error")
            XCTAssertNotNil(self.viewModel.errorMessage, "Error message should not be nil on failure")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPartialSuccess() {
        let mockAPIService = MockAPIService()
        mockAPIService.shouldFailAirPollution = true
        viewModel = WeatherViewModel(apiService: mockAPIService)

        let expectation = self.expectation(description: "Partial weather data fetched")
        viewModel.fetchWeather(forCity: "New York")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.viewModel.forecastData, "Forecast data should not be nil if the API succeeds")
            XCTAssertNotNil(self.viewModel.currentWeather, "Current weather should not be nil if the API succeeds")
            XCTAssertNil(self.viewModel.airPollution, "Air pollution data should be nil if the API fails")
            XCTAssertNotNil(self.viewModel.errorMessage, "Error message should be set if an API fails")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}
