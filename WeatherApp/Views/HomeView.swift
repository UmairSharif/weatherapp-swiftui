//
//  ContentView.swift
//  WeatherApp
//
//  Created by Umair on 27/01/2025.
//

import SwiftUI
import CoreLocation
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName = "London"
    
    var body: some View {
        ZStack {
            gradientBackground(for: viewModel.currentWeather?.weather.first?.icon ?? "01d")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage: errorMessage)
                } else {
                    weatherContent
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchWeather(forCity: cityName)
        }
    }
    
    private var weatherContent: some View {
        VStack {
            
            VStack(spacing: 15) {
                Text(viewModel.forecastData?.city.name ?? "Loading...")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                if let weather = viewModel.currentWeather?.main {
                    Text("\(Int(weather.temp))°")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("From \(Int(weather.temp_min))° to \(Int(weather.temp_max))°")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let condition = viewModel.currentWeather?.weather.first?.desc {
                        Text(condition.capitalized)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                } else {
                    Text("Fetching weather...")
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .background(.gray.opacity(0.7))
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .padding(.horizontal)
            
            VStack {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 2), spacing: 0) {
                    WeatherDetailRow(title: "Humidity", value: "\(viewModel.currentWeather?.main.humidity ?? 0)%")
                    WeatherDetailRow(title: "Pressure", value: "\(viewModel.currentWeather?.main.pressure ?? 0) hPa")
                }
                HStack(alignment: .center, content: {
                    WeatherDetailRow(title: "Wind Speed", value: "\(Int(viewModel.currentWeather?.wind.speed ?? 0)) m/s")
                })
            }
            .padding()
            .background(.material)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack(spacing: 15) {
            Text("Error")
                .font(.title)
                .foregroundColor(.red)
                .padding(.bottom, 5)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(.gray.opacity(0.7))
                .cornerRadius(12)
                .padding(.horizontal, 20)
            
            Button(action: {
                cityName = "New York"
                viewModel.fetchWeather(forCity: cityName)
            }) {
                Text("Retry")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    private func getPrecipitationInfo(_ weather: CurrentData) -> String {
        if let rain = weather.rain?.hour1 {
            return "\(rain) mm"
        } else if let snow = weather.snow?.hour1 {
            return "\(snow) mm"
        } else {
            return "0"
        }
    }
}

struct WeatherDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text(value)
                    .font(.title2 .bold())
                Text(title)
                    .font(.caption)
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
