//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Vapor
import Fluent

final class User: Model, Content {
        
    static let schema = "users"

    struct FieldKeys {
        
        static var name: FieldKey { "name" }
        static var phone: FieldKey { "phone" }
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }
    
    // MARK: - fields
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.name)
    var name: String
    
    @Field(key: FieldKeys.phone)
    var phone: String
    
    @Field(key: FieldKeys.email)
    var email: String
    
    @Field(key: FieldKeys.password)
    var password: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: User.IDValue? = nil,
         name: String,
         phone: String,
         email: String,
         password: String,
         created_at: Date = Date())
    {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.password = password
        self.createdAt = created_at
    }
}

extension User {
    struct Create: Content {
        var name: String
        var phone: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("phone", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$phone
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    func generateToken() throws -> Token {
       try .init(
            userId: self.requireID(),
            value: [UInt8].random(count: 16).base64
        )
    }
}


extension User: Authenticatable {}

struct UserModelFragmentAuthenticator: RequestAuthenticator {
    typealias UserModel = User

    func authenticate(request: Request) -> EventLoopFuture<Void> {
        UserModel.find(UUID(uuidString: request.url.fragment ?? ""), on: request.db)
        .map {
            if let user = $0 {
                request.auth.login(user)
            }
        }
    }
}
