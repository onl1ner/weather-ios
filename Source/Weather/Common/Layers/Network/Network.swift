//
//  Network.swift
//  Weather
//
//  Created by Tamerlan Satualdypov on 23.07.2021.
//

import UIKit

protocol NetworkProtocol {
    func image(with id: String, completion: @escaping (UIImage?) -> ()) -> ()
    func getCurrentWeather(for lat: Double, lon: Double, completion: @escaping (Result<Weather, NetworkError>) -> ()) -> ()
}

final class Network: NetworkProtocol {
    
    public static let shared: NetworkProtocol = Network()
    
    private func deserialize<T : Codable>(data : Data, as objectType : T.Type) -> T? {
        return try? JSONDecoder().decode(objectType, from: data)
    }
    
    private func dataTask(for endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> () {
        URLSession.shared.dataTask(with: endpoint.url, completionHandler: completion).resume()
    }
    
    private func processDataTask(with data: Data?, response: URLResponse?, error: Error?) -> Result<[String: Any], NetworkError> {
        if error != nil {
            return .failure(.transport)
        }
        
        if let data = data, let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
           let dictionary = object as? [String: Any] {
            return .success(dictionary)
        }
        
        return .failure(.internal)
    }
    
    private func performCall(to endpoint: Endpoint, completion: @escaping (Result<[String: Any], NetworkError>) -> ()) -> () {
        self.dataTask(for: endpoint) { data, response, error in
            completion(self.processDataTask(with: data, response: response, error: error))
        }
    }
    
    // MARK: - Concrete Implementations
    
    public func image(with id: String, completion: @escaping (UIImage?) -> ()) -> () {
        self.dataTask(for: .getImage(for: id)) { data, response, error in
            guard error == nil, let data = data else { return completion(nil) }
            completion(.init(data: data))
        }
    }
    
    public func getCurrentWeather(for lat: Double, lon: Double, completion: @escaping (Result<Weather, NetworkError>) -> ()) -> () {
        self.performCall(to: .getCurrentWeather(for: lat, lon: lon)) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let dictionary):
                        guard let current = dictionary["current"] as? [String: Any],
                              let data = try? JSONSerialization.data(withJSONObject: current),
                              let weather = self.deserialize(data: data, as: Weather.self)
                        else { return completion(.failure(.internal)) }
                        
                        completion(.success(weather))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    private init() { }
}
