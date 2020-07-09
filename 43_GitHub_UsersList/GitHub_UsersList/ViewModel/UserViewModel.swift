//
//  UserViewModel.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import Foundation

class UserViewModel {
    
    private var apiService = APIService()
    private var usersData = [User]()
    
    func fetchUsersData(completion: @escaping () -> ()) {
        
        apiService.getGitHubUsersData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.usersData = listOf
                completion()
            case .failure(let error):
                // Something
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if usersData.count != 0 {
            return usersData.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> User {
        return usersData[indexPath.row]
    }
}
