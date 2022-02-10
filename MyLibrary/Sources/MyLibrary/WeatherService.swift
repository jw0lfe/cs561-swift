import Alamofire
import Foundation

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void)
    func getToken(completion: @escaping (_ token: String) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let urlWeather = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/weather"
    let urlHello = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/hello"
    let urlAuth = "http://ec2-52-12-191-147.us-west-2.compute.amazonaws.com:3000/v1/auth"
    //let urlWeather = "http://localhost:3000/v1/weather"
    //let urlHello = "http://localhost:3000/v1/hello"
    //let urlAuth = "http://localhost:3000/v1/auth"

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        self.getToken(completion: {token in let headers : HTTPHeaders = ["Authorization": "Bearer  \(token)"]
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
        })
    }

    func getGreeting(completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void) {
        self.getToken(completion: {token in let headers : HTTPHeaders = ["Authorization": "Bearer \(token)"]
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
        })
    }

    func getToken(completion: @escaping (_ token: String) -> Void) {
        let parameters: Parameters = [
            "username": "jabob",
            "password": "D0nChaKn0w"
        ]

        AF.request(self.urlAuth, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<500).responseDecodable(of: Token.self) { response in
            switch response.result {
            case let .success(accesstoken):
                let token = accesstoken.accesstoken
                completion(token)

            case let .failure(error):
                completion("error")
            }
        }

        // AF.request(self.urlAuth, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<500).responseJSON { response in
        //     switch response.result {
        //         case let .success(value):
        //             if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: Any] {

        //                 if let token = json["accesstoken"] as? String {
        //                     completion(token)
        //                 }
        //             }

        //         case let .failure(error):
        //             completion("error")
        //     }
        // }

        // AF.request(self.urlAuth, method: .post, parameters: parameters).validate(statusCode: 200..<500).responseDecodable(of: Token.self) { AFdata in
        //     //https://www.hackingwithswift.com/example-code/system/how-to-parse-json-using-jsonserialization
        //     do {
        //         if let json = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] {
        //             if let token = json["accesstoken"] as? String {
        //                 let tokens = String(token)
        //                 print(tokens)
        //                 completion(tokens)
        //             }
        //         }
        //     } catch {
        //         print("Error")
        //         completion("")
        //     }
        // }
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}

private struct Greeting: Decodable {
    let greeting: String
}

private struct Token: Decodable {
    let accesstoken: String
    let expires: String
}
