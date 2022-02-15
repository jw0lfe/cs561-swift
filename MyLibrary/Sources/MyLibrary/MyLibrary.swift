public class MyLibrary {
    private let weatherService: WeatherService

    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
    }

    public func getWeather(completion: @escaping (String?) -> Void) {
                
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getTemperature { response in
            switch response {
            case let .failure(error):
                print(error)
                completion("error getting weather")

            case let .success(temperature):
                print("The temp is: " + String(temperature))
                completion(String(temperature))
            }
        }
    }

    public func getHello(completion: @escaping (String?) -> Void) {
                
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getGreeting { response in
            switch response {
            case let .failure(error):
                completion("error getting greeting")

            case let .success(greeting):
                print("Greeting: " + greeting)
                completion(greeting)
            }
        }
    }

    public func getToken(completion: @escaping (String?) -> Void) {
                
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getToken { response in
            switch response {
            case let .failure(error):
                completion("error getting token")

            case let .success(token):
                print("Token is: " + token)
                completion(token)
            }
        }
    }

    

    /// Sample usage:
    ///   `contains(558, "8")` would return `true` because 588 contains 8.
    ///   `contains(557, "8")` would return `false` because 577 does not contain 8.
    // private func contains(_ lhs: Int, _ rhs: Character) -> Bool {
    //     return String(lhs).contains(rhs)
    // }
}
