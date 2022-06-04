//
//  UserListObserver.swift
//  Observer-Pattern-Example
//
//  Created by Mac on 04/06/22.
//

import Foundation

class UserListObserver: NetworkObserver {
    var observers: [NetworkObservable] = []
    
    func addObserver(observer: NetworkObservable) {
        
    }
    
    func removeObserver(observer: NetworkObservable) {
        
    }
    
    func notifyObserver(with result: Result<[User], Error>) {
        
    }
}
