//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Vapor
import Fluent

final class Sale: Model, Content {
        
    static let schema = "sales"

    struct FieldKeys {
        static var client_name: FieldKey { "client_name" }
        static var client_number: FieldKey { "client_number" }
        static var quantity: FieldKey { "quantity" }
        static var unit_price: FieldKey { "unit_price" }
        static var total_price: FieldKey { "total_price" }
        static var location: FieldKey { "location" }
        static var status: FieldKey { "status" }
    }
    
    // MARK: - fields
    
    @ID()
    var id: UUID?
    
    @Parent(key: "box_id")
    var box: Box
    
    @Field(key: FieldKeys.client_name)
    var client_name: String
    
    @Field(key: FieldKeys.client_number)
    var client_number: Int
    
    @Field(key: FieldKeys.quantity)
    var quantity: Int
    
    @Field(key: FieldKeys.unit_price)
    var unit_price: Int
    
    @Field(key: FieldKeys.total_price)
    var total_price: Int
    
    @Field(key: FieldKeys.location)
    var location: String
    
    @Field(key: FieldKeys.status)
    var status: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil,
         boxId: Box.IDValue,
        client_name: String,
        client_number: Int,
        quantity: Int,
        unit_price: Int,
        total_price: Int,
        location: String,
        status: Bool,
        created_at: Date = Date())
    {
        self.id = id
        self.$box.id = boxId
        self.client_name =  client_name
        self.client_number =  client_number
        self.quantity =  quantity
        self.unit_price =  unit_price
        self.total_price = total_price
        self.location = location
        self.status = status
        self.createdAt = created_at
    }
}
