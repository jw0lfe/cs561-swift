public class MyLibrary {
    private let weatherService: WeatherService

    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
    }

    public func getWeather(completion: @escaping (Int?) -> Void) {
                
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getTemperature { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(0)

            case let .success(temperature):
                print(temperature)
                completion(temperature)
            }
        }
    }

    public func getHello(completion: @escaping (String?) -> Void) {
                
        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getGreeting { response in
            switch response {
            case let .failure(error):
                completion("failed")

            case let .success(greeting):
                print(greeting)
                completion(greeting)
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
