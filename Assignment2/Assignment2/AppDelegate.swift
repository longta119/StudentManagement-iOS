//
//  AppDelegate.swift
//  Assignment2
//
//  Created by qta on 7/10/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Assignment2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //store a student info to core data
    func storeStudentInfo (id: Int, firstname: String, lastname: String, gender: String, course: String, age: Int, address: String, image: Data) {
        let context = getContext()
        //retrive the entity
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the entity values
        transc.setValue(id, forKey: "studentID")
        transc.setValue(firstname, forKey: "firstName")
        transc.setValue(lastname, forKey: "lastName")
        transc.setValue(gender, forKey: "gender")
        transc.setValue(course, forKey: "courseStudy")
        transc.setValue(age, forKey: "age")
        transc.setValue(address, forKey: "address")
        transc.setValue(image, forKey: "image")
        //save the object
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }
    
    //get all student info from core data and store as a string
    func getStudentInfo () -> String {
        var info = ""
        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        do {
            //go get the result
            let searchResult = try getContext().fetch(fetchRequest)
            //convert to NSManagedObject to use 'for' loop
            for trans in searchResult as [NSManagedObject] {
                let id = String(trans.value(forKey: "studentID") as! Int)
                let firstName = trans.value(forKey: "firstName") as! String
                let lastName = trans.value(forKey: "lastName") as! String
                let gender = trans.value(forKey: "gender") as! String
                let course = trans.value(forKey: "courseStudy") as! String
                let age = String(trans.value(forKey: "age") as! Int)
                let address = trans.value(forKey: "address") as! String
                //let image = String(trans.value(forKey: "image") as! Data)
                info = info + id + ", " + firstName + ", " + lastName + ", " + gender + ", " + course + ", " + age + ", " + address + "\n"
            }
        } catch  {
            print("Error with request: \(error)")
        }
        return info
    }
    
    //retrieve from core data and fetch an image associated with the student
    func getStudentImage(id: Int) -> UIImage {
        var image = UIImage(named: "logo.jpg")
        let fetchRequest : NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "studentID == %d", id)
        do {
            let fetchResults = try getContext().fetch(fetchRequest)
            if let aImage = fetchResults.first {
                let savedImage = aImage.image
                image = UIImage(data: savedImage!)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return image!
    }
    
    @nonobjc public class func fetchRequest () -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }
    
    //delete a student record from core data
    func removeARecord(id: Int) {
        let context = getContext()
        //delete a selected row according to the studentID attribute
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        deleteFetch.predicate = NSPredicate(format: "studentID == %d", id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error.")
        }
    }
    
    //update a student info to core data
    func updateStudentInfo (id: Int, firstname: String, lastname: String, gender: String, course: String, age: Int, address: String, image: Data) {
        let context = getContext()
        let updateFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        updateFetch.predicate = NSPredicate(format: "studentID == %d", id)
        do {
            let updateRequest = try context.fetch(updateFetch)
            let transc = updateRequest[0] as! NSManagedObject
            transc.setValue(id, forKey: "studentID")
            transc.setValue(firstname, forKey: "firstName")
            transc.setValue(lastname, forKey: "lastName")
            transc.setValue(gender, forKey: "gender")
            transc.setValue(course, forKey: "courseStudy")
            transc.setValue(age, forKey: "age")
            transc.setValue(address, forKey: "address")
            transc.setValue(image, forKey: "image")
        } catch {
            print("Fetch faild: \(error)")
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }
    
    //store an exam info to core data
    func storeExamInfo (id: Int, name: String, date: Date, location: String) {
        let context = getContext()
        //retrive the entity
        let entity = NSEntityDescription.entity(forEntityName: "Exam", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the entity values
        transc.setValue(id, forKey: "studentID")
        transc.setValue(name, forKey: "name")
        transc.setValue(date, forKey: "date")
        transc.setValue(location, forKey: "location")
        //save the object
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }
    
    //get all exam info from core data and store as a string
    func getExamInfo (id: Int) -> String {
        var info = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //create a fetch request, telling it about the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exam")
        fetchRequest.predicate = NSPredicate(format: "studentID == %d", id)
        do {
            //go get the result
            let searchResult = try getContext().fetch(fetchRequest)
            //convert to NSManagedObject to use 'for' loop
            for trans in searchResult as [NSManagedObject] {
                let name = trans.value(forKey: "name") as! String
                let location = trans.value(forKey: "location") as! String
                let date = dateFormatter.string(from: trans.value(forKey: "date") as! Date)
                if ((trans.value(forKey: "date") as! Date).timeIntervalSinceNow.sign == .minus){
                    info = info + name + ", " + date + ", " + location + " [PAST]" + "\n"
                } else {
                    info = info + name + ", " + date + ", " + location + " [FUTURE]" + "\n"
                }
            }
        } catch  {
            print("Error with request: \(error)")
        }
        return info
    }
    
    //delete an exam record from core data
    func removeExamRecord(name: String) {
        let context = getContext()
        //delete a selected row according to the name attribute
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
        deleteFetch.predicate = NSPredicate(format: "name == %@", name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error.")
        }
    }
    
    //delete all exam records
    func removeRecord () {
        let context = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }
    
}

