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
    static var number: Self { "number" }
}

final class Death: Model, Content {

    static let schema = "death"

    @ID()
    var id: UUID?
    
    @Parent(key: "box_id")
    var box: Box
    
    @Field(key: .number)
    var number: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, number: Int, boxId: UUID, created_at: Date = Date())
    {
        self.id = id
        self.number = number
        self.$box.id = boxId
        self.createdAt = created_at
    }
}
