//
//  StorageManager.swift
//  ToDoList01
//
//  Created by Денис Александров on 08.08.2024.
//

import CoreData
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList01")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}

    // Сохранение контекста
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Добавление новой задачи
    func createTask(withTitle title: String) -> TodoTask {
        let task = TodoTask(context: context)
        task.title = title
        saveContext()
        return task
    }

    // Получение всех задач
    func fetchTasks() -> [TodoTask] {
        let fetchRequest: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
            return []
        }
    }

    // Обновление задачи
    func updateTask(_ task: TodoTask, withTitle title: String) {
        task.title = title
        saveContext()
    }

    // Удаление задачи
    func deleteTask(_ task: TodoTask) {
        context.delete(task)
        saveContext()
    }
}

