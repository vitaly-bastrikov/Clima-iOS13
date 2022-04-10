import Foundation

class WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=2e3426ce5ce89a5f758f02495589c940&units=metric"
    var delegate: WeatherDelegate?
    
    func updateWeather(_ city: String) {
        let completeUrl = url + "&q=" + city
        print(completeUrl)
        makeRequest(completeUrl)
    }
    
    func updateWeather(_ long: Double, _ lat: Double) {
        let completeUrl = url + "&lon=" + String(long) + "&lat=" + String(lat)
        print(completeUrl)
        makeRequest(completeUrl)
    }
    
    func makeRequest(_ urlString: String) {
        print(urlString)
        let url = URL(string: urlString)!
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if (error != nil) {
                self.delegate?.didFailWithError(error!)
                return
            }
            if let saveData = data {
                if let weather = self.parseJson(saveData) {
                    self.delegate?.didUpdateWeather(self, weather)
                }
                
                
            }
        }
        task.resume()
    }
    
    func parseJson(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherResponseModel.self, from: data)
            let id = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            return WeatherModel(city: city, temp: temp, id: id)
            
        }
        catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
}
