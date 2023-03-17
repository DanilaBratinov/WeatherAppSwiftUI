import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    enum Links: String {
        case weather = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=28ede8c4626bcba101f47c928f53f1b9&units=metric"
    }
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>)  -> Void) {
                guard let url = URL(string: url) else {
                    completion(.failure(.invalidURL))
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let type = try decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(type))
                        }
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }.resume()
            }
}
