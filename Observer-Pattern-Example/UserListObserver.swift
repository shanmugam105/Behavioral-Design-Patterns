//
//  UserListObserver.swift
//  Observer-Pattern-Example
//
//  Created by Mac on 04/06/22.
//

import Foundation

protocol UserDetailsObservable: AnyObject {
    func updateResult()
    func updateError(error: Error)
}

protocol UserDetailsObserver: AnyObject {
    var observers: [UserDetailsObservable] { get set }
    func addObserver(observer: UserDetailsObservable)
    func removeObserver(observer: UserDetailsObservable)
    func notifyObserver(with result: Result<[User], Error>)
}

class UserListObserver: UserDetailsObserver {
    static let shared = UserListObserver()
    private init() {}
    
    var observers: [UserDetailsObservable] = []
    
    var users: [User]?
    
    func addObserver(observer: UserDetailsObservable) {
        observers.append(observer)
    }
    
    func removeObserver(observer: UserDetailsObservable) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
            print("-> ","\(String(describing: observer.self)) removed.")
        }
    }
    
    func notifyObserver(with result: Result<[User], Error>) {
        observers.forEach { observable in
            switch result {
            case .success(let users):
                self.users = users
                observable.updateResult()
            case .failure(let error):
                observable.updateError(error: error)
            }
        }
    }
    // MARK: Business Logic
    func getUserList() {
        NetworkServiceHandler.shared.request(
            route: .user,
            type: [User].self,
            completion: notifyObserver
        )
    }
}
