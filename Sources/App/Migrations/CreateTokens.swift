//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 11/3/20.
//

import Fluent

// 1
struct CreateTokens: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 2
    database.schema(Token.schema)
       // 3
      .id()
      .field("user_id", .uuid, .references("users", "id"))
      .field("value", .string, .required)
      .unique(on: "value")
      .create()
  }

  // 5
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Token.schema).delete()
  }
}
