import UIKit
import CoreLocation

class WeatherViewController: UIViewController, WeatherDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    func didUpdateWeather(_ weatherManager: WeatherManager ,_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f", weather.temp)
            self.cityLabel.text = weather.city
            self.conditionImageView.image = UIImage(systemName: weather.getImage(weather.id))
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        textFieldDidEndEditing(searchTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            } else {
                textField.placeholder = "Type something"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let city = searchTextField.text {
                weatherManager.updateWeather(city)
            }
            
            searchTextField.text = ""
            
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let location = locations.last {
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            
            weatherManager.updateWeather(lon, lat)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}



