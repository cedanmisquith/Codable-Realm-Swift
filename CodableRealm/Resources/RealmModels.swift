//
//  RealmModels.swift
//  CodableRealm
//
//  Created by Cedan Misquith on 21/10/21.
//

import Realm
import RealmSwift

@objcMembers class Users: Object, Decodable {
    dynamic var data = RealmSwift.List<UserData>()
    enum CodingKeys: String, CodingKey {
        case data
    }
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let users = try container.decodeIfPresent([UserData].self, forKey: .data) else { return }
        data.append(objectsIn: users)
    }
    override init() {
        super.init()
    }
}

@objcMembers class UserData: Object, Decodable {
    dynamic var id: Int = 0
    dynamic var email: String = ""
    dynamic var first_name: String = ""
    dynamic var  last_name: String = ""
    dynamic var  avatar: String = ""
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case first_name
        case last_name
        case avatar
    }
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        first_name = try container.decode(String.self, forKey: .first_name)
        last_name = try container.decode(String.self, forKey: .last_name)
        avatar = try container.decode(String.self, forKey: .avatar)
    }
    override init() {
        super.init()
    }
}
