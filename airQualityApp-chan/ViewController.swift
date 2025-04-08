//
//  ViewController.swift
//  airQualityApp-chan
//
//  Created by Christopher Chan on 4/7/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getAirQualityButton(_ sender: Any) {
        // Make an api call
        // Parse the response
        // Show the proper image based on the response
        fetchAirQuality()
    }
    
    func fetchAirQuality(){
            // http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
            
            // Get components for API call
            let apiKey = "37e86086-609a-43e0-af9d-b1df9ccf276e"
            let city = "Los Angeles"
            let state = "California"
            let country = "USA"
            
            let urlString = "https://api.airvisual.com/v2/city?city=\(city)&state=\(state)&country=\(country)&key=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                print("Incorrect Website")
                return
            }
            
            // Make API call
            let task = URLSession.shared.dataTask(with:url) {data, response, error in
                //print("Data: \(data)")
                //print("Response: \(response)")
                //print("Error: \(error)")
                
                // Parse API reponse
                guard let responseData = data else {
                    // Let user know that there is no data
                    return
                }
                
                do {
                    // Way to catch certain errors when converting data object to json object
                    // Narrows the data from the package to the desired data (aqius in this case)
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let dataFromJSON = json["data"] as? [String: Any],
                       let currentFromJSON = dataFromJSON["current"] as? [String: Any],
                       let pollutionFromJSON = currentFromJSON["pollution"] as? [String: Any],
                       let aqius = pollutionFromJSON["aqius"] as? Int
                    {
                        DispatchQueue.main.async {
                            self.showImageForAqiusValue(aqius)
                        }
                        
                    }
                } catch {
                    // Let user know that there is no data
                    print("Error gettting json")
                }
            }
            task.resume()
            
            // Show the right image
        }
        
        func showImageForAqiusValue(_ value: Int) {
            print("Aq value is: \(value)")
            if (value <= 50) {
                // Show good image
                imageView.image = UIImage(named: "bruh")
            } else if (value <= 100) {
                // Show ok image
                imageView.image = UIImage(named: "meh")
            } else {
                // Show bad image
                imageView.image = UIImage(named: "bruh")
        }
    }
}

