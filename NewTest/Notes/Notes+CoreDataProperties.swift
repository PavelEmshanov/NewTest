//
//  Notes+CoreDataProperties.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: Data?

}

extension Notes : Identifiable {

    //Изменение заметки
    func updateNote(title: String, noteText: String) {
        self.title = title
        self.text = noteText
        self.date = Date()
        try? managedObjectContext?.save()
    }
    
    
    //Изменение заметки с картинкой
    func updateNote(title: String, noteText: String, image: Data) {
        self.title = title
        self.text = noteText
        self.image = image
        self.date = Date()
        try? managedObjectContext?.save()
    }
    
    //Удаление заметки
    func deletNote() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
}

