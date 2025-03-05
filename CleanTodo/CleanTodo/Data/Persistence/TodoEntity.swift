//
//  TodoEntity.swift
//  CleanTodo
//
//  Created by 정정욱 on 3/4/25.
//

import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject {
    @NSManaged public var id: Int64 
    @NSManaged public var title: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
}
