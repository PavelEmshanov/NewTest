//
//  Model.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//
//

import Foundation
import CoreData

class CoreManager {
    static let shared = CoreManager()
    var notes = [Notes]()

    private init() {
        fetchAllNotes()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NewTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Загрузка заметок
    func fetchAllNotes() {
        let request = Notes.fetchRequest()
        if let notes = try? persistentContainer.viewContext.fetch(request) {
            self.notes = notes
        }
    }
    
    // Добавление заметки
    func addNewNote(title: String, noteText: String) {
        let note = Notes(context: persistentContainer.viewContext)
        note.title = title
        note.text = noteText
        note.date = Date()
        saveContext()
        fetchAllNotes()
    }
    
    // Добавление заметки с изображением
    func addNewNote(title: String, noteText: String, image: Data) {
        let note = Notes(context: persistentContainer.viewContext)
        note.title = title
        note.text = noteText
        note.image = image
        note.date = Date()
        saveContext()
        fetchAllNotes()
    }
}
