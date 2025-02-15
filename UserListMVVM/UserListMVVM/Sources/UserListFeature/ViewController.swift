//
//  ViewController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private lazy var userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        fetchUsers()
    }
    
    private func fetchUsers() {
        userService.fetchUsers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched users")
                case .failure(let error):
                    print("Error fetching users: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

