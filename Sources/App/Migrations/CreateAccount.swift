//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 24/11/2020.
//

import Fluent


struct CreateAccount: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Account.schema)
        .id()
        .field("amount", .int, .required)
        .field("created_at", .datetime, .required)
        .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Account.schema).delete()
  }
}
