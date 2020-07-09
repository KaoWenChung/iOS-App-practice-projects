//
//  ApiService.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import Foundation

class APIService{
    
    private var dataTask: URLSessionDataTask?
    
    func getGitHubUsersData(completion: @escaping (Result<[User], Error>) -> Void) {
        
        let gitHubUserURL = "https://api.github.com/users?page=1&per_page=100"
        
        guard let url = URL(string: gitHubUserURL) else { return }
        
        // Create URL Session - Work on the background
        dataTask = URLSession.shared.dataTask(with: url) { ( data, response, error ) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let deconder = JSONDecoder()
                let jsonData = try deconder.decode([User].self, from:  data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
