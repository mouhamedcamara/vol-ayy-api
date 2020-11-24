//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 24/11/2020.
//


import Fluent
import Vapor



final class Account: Model, Content {

    static let schema = "amount"

    @ID()
    var id: UUID?
    
    @Field(key: "amount")
    var amount: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, amount: Int, created_at: Date = Date())
    {
        self.id = id
        self.amount = amount
        self.createdAt = created_at
    }
}
