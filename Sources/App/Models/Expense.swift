//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/4/20.
//


import Fluent
import Vapor

extension FieldKey
{
    static var description: Self { "description" }
    static var amount: Self { "amount" }
}

final class Expense: Model, Content {

    static let schema = "expenses"

    @ID()
    var id: UUID?
    
    @Parent(key: "box_id")
    var box: Box
    
    @Field(key: .amount)
    var amount: Int
    
    @Field(key: .description)
    var description: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, amount: Int, description: String, boxId: UUID, created_at: Date = Date())
    {
        self.id = id
        self.amount = amount
        self.description = description
        self.$box.id = boxId
        self.createdAt = created_at
    }
}

