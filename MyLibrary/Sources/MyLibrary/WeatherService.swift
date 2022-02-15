import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void)
    func getToken(completion: @escaping (_ response: Result<String /* Token */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let urlWeather = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/weather"
    let urlHello = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/hello"
    let urlAuth = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/auth"
    // let urlWeather = "http://localhost:3000/v1/weather"
    // let urlHello = "http://localhost:3000/v1/hello"
    // let urlAuth = "http://localhost:3000/v1/auth"

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        self.getToken(completion: {response in 
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):   
                let headers : HTTPHeaders = [.authorization(bearerToken: token), .accept("application/json")]                   

                AF.request(self.urlWeather, method: .get, headers: headers).validate(statusCode: 200..<500).responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case let .success(weather):
                        let temperature = weather.main.temp
                        let temperatureAsInteger = Int(temperature)
                        print(temperatureAsInteger)
                        completion(.success(temperatureAsInteger))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        })
    }

    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void) {
        self.getToken(completion: {response in 
            switch response {
            case let .failure(error):
                print(error)
                completion(.failure(error))
            case let .success(token):
                let headers : HTTPHeaders = [.authorization(bearerToken: token), .accept("application/json")]

                AF.request(self.urlHello, method: .get, headers: headers).validate(statusCode: 200..<500).responseDecodable(of: Greeting.self) { response in
                    switch response.result {
                    case let .success(greeting):
                        let hello = greeting.greeting
                        print(hello)
                        completion(.success(hello))

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        })
    }

    func getToken(completion: @escaping (_ response: Result<String /* Token */, Error>) -> Void) {
        let payload = Payload(
            username: "jabob",
            password: "D0nChaKn0w"
        )

        AF.request(self.urlAuth, method: .post, parameters: payload, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<500).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(access_token):
                let token = access_token.access_token
                completion(.success(token))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private struct Weather: Decodable {
    let main: Main;

    struct Main: Decodable {
        let temp: Double;
    }
}

private struct Greeting: Decodable {
    let greeting: String;
}

private struct Token: Decodable {
    let access_token: String;
    let expires: String;

    enum CodingKeys: String, CodingKey {
        case access_token = "access-token"
        case expires = "expires"
    }
}

private struct Payload: Encodable {
    let username: String;
    let password: String;
}
