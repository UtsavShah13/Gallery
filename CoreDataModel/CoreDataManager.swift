//
//  CoreDataManager.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 02/04/24.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    public static let shared = CoreDataManager()
      let identifier: String  = "app.com.galleryApp"       //Your framework bundle ID
      let model: String       = "GalleryCoreData"                      //Model name
      
  //    ImageList
      
      lazy var persistentContainer: NSPersistentContainer = {
              let messageKitBundle = Bundle(identifier: self.identifier)
              let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
              let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
              
              let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
              container.loadPersistentStores { (storeDescription, error) in
                  
                  if let err = error{
                      fatalError(err.localizedDescription)
                }
            }
            
            return container
        }()
    
    public func createImageList(id: Int64, previewImage: String) {
            
            let context = persistentContainer.viewContext
        let contact = NSEntityDescription.insertNewObject(forEntityName: "ImageList", into: context) as! ImageList
            
            contact.id = id
            contact.previewImage  = saveImageToCoreData(from: previewImage)
            
            do {
                try context.save()
                print("ImageList saved succesfuly")
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
    public func fetch() -> [Any] {
        var array : [Any] = []
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ImageList>(entityName: "ImageList")
        
        do{
            let ImageList = try context.fetch(fetchRequest)
            array = ImageList
        }catch let fetchErr {
            print(fetchErr)
        }
        return array
    }
    
    public func deleteAllData() {
        let context = persistentContainer.viewContext
        
        // Fetch all data in your Core Data model
        let entityNames = persistentContainer.managedObjectModel.entities.map { $0.name }
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageList")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                print("All data deleted successfully.")
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Save the context to persist the changes
        do {
            try context.save()
        } catch {
            print("Failed to save changes after clearing data:", error.localizedDescription)
        }
    }
    
    func saveImageToCoreData(from imageURL: String) -> Data {
        // Download image data from URL
        guard let url = URL(string: imageURL) else { return Data() }
        guard let imageData = try? Data(contentsOf: url) else {
            print("Failed to download image data from URL:", imageURL)
            return Data()
        }
        
        return imageData
    }

}
