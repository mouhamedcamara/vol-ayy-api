//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Vapor
import Fluent

final class Box: Model, Content {
        
    static let schema = "boxes"

    struct FieldKeys {
        
        static var name: FieldKey { "name" }
        static var number: FieldKey { "number" }
        static var death: FieldKey { "death" }
        static var age: FieldKey { "age" }
        static var revenu: FieldKey { "revenu" }
        static var expense: FieldKey { "expense" }
        static var vendu: FieldKey { "vendu" }
        static var createdAt: FieldKey { "createdAt" }
    }
    
    // MARK: - fields
    
    @ID()
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: FieldKeys.name)
    var name: String
    
    @Field(key: FieldKeys.number)
    var number: Int
    
    @Field(key: FieldKeys.death)
    var death: Int
    
    @Field(key: FieldKeys.age)
    var age: Int
    
    @Field(key: FieldKeys.revenu)
    var revenu: Int
    
    @Field(key: FieldKeys.expense)
    var expense: Int
    
    @Field(key: FieldKeys.vendu)
    var vendu: Int
    
    @Children(for: \.$box)
    var sales: [Sale]
    
    @Children(for: \.$box)
    var expenses: [Expense]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil,
         userId: User.IDValue,
        name: String,
        number: Int,
        expense: Int,
        age: Int = 0,
        vendu: Int = 0,
        revenu: Int = 0,
        created_at: Date = Date()
        )
    {
        self.id = id
        self.$user.id = userId
        self.name =  name
        self.number = number
        self.expense = expense
        self.age = age
        self.vendu = vendu
        self.revenu = revenu
        self.createdAt = created_at
        
    }
}
