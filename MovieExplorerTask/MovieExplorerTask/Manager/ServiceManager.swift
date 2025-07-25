//
//  ServiceManager.swift
//  MovieExplorer
//
//  Created by Apple on 23/07/25.
//

import Foundation
import Alamofire

class ServiceManager {
    static let shared = ServiceManager()
    
    func fetchPopularMovies(query: String? = nil, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(APIConstants.popularMovie)?api_key=\(APIConstants.apiKey)&page=\(page)"
        AF.request(url, parameters: nil).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data.results))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func searchMovies(query: String? = nil, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let query = query, !query.isEmpty else {return}
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(APIConstants.search)?api_key=\(APIConstants.apiKey)&query=\(queryEncoded)&page=\(page)"
        
        AF.request(url, parameters: nil).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data.results))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func fetchNowPlaying(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(APIConstants.baseURL)/movie/now_playing"
        let parameters: [String: Any] = ["api_key": APIConstants.apiKey]
        
        AF.request(url, parameters: parameters).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {
        let url = "\(APIConstants.baseURL)/movie/\(id)?api_key=\(APIConstants.apiKey)&language=en-US"
        
        AF.request(url).responseDecodable(of: MovieDetail.self) { response in
            switch response.result {
            case .success(let detail):
                completion(detail)
            case .failure(let error):
                print("Detail Error: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchMovieTrailer(movieID: Int, completion: @escaping (String?) -> Void) {
        let url = "\(APIConstants.baseURL)/movie/\(movieID)/videos?api_key=\(APIConstants.apiKey)&language=en-US"
        
        AF.request(url).responseDecodable(of: VideoResponse.self) { response in
            switch response.result {
            case .success(let videoResponse):
                // Get YouTube trailer
                if let trailer = videoResponse.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" }) {
                    completion(trailer.key)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Trailer fetch error: \(error)")
                completion(nil)
            }
        }
    }
    
}

struct MovieResponse: Codable {
    let results: [Movie]
}
