//
//  RealmDataManager.swift
//  CodableRealm
//
//  Created by Cedan Misquith on 21/10/21.
//

import RealmSwift

class RealmDataManager {
    private var testRealm: Realm!
    static let sharedInstance = RealmDataManager()
    private init() {
        do {
            testRealm = try Realm()
        } catch {
            print("Error initializing realm")
        }
    }
    func saveUsers(users: Users) {
        do {
            try testRealm.write {
                testRealm.add(users)
            }
        } catch {
            print("Failed To Save Users")
        }
    }
    func getAllUsers() -> [Users]? {
        var allUsers = [Users]()
        let users = testRealm.objects(Users.self)
        for user in users {
            allUsers.append(user)
        }
        return allUsers
    }
}
