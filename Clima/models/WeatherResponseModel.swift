import Foundation

struct WeatherResponseModel: Codable {
    var name: String
    var weather: [Weather]
    var main: Main
}

struct Weather: Codable {
    var id: Int
    var description: String
}

struct Main: Codable {
    var temp: Double
}
