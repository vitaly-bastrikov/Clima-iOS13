import Foundation

protocol WeatherDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
