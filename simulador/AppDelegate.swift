//
//  AppDelegate.swift
//  simulador
//
//  Created by Chucho on 11/9/16.
//  Copyright © 2016 UNOi. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "simulador")
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
    
    func storeTranscription (personId: Int, personName: String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Login", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(personId, forKey: "personId")
        transc.setValue(personName, forKey: "personName")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getTranscriptions () -> Int{
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        var myId: Int = 0
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for trans in searchResults as [NSManagedObject] {
                myId = trans.value(forKey: "personId") as! Int
            }
        } catch {
            print("Error with request: \(error)")
        }
        return myId
    }
    
    func storeProposal (vendedorId: Int, schoolId: Int, schoolName: String, cp: Int, col: String, street: String, streetNo: String, contactName: String, contactMail: String, aulaDigital: Int, makerCart: Int, aulaMaker: Int, proyector: Int, telepresencia: Int, aceleracon: Int, certificacion: Int, desarrollo: Int, totalPesos: Double, totalAnios:Int, totalPesosExt: Double, totalPuntos: Int) {
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Propuestas", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        transc.setValue(schoolId, forKey: "schoolId")
        transc.setValue(schoolName, forKey: "schoolName")
        transc.setValue(cp, forKey: "cp")
        transc.setValue(col, forKey: "col")
        transc.setValue(street, forKey: "street")
        transc.setValue(streetNo, forKey: "streetNo")
        transc.setValue(contactName, forKey: "contactName")
        transc.setValue(contactMail, forKey: "contactMail")
        transc.setValue(aulaDigital, forKey: "aulaDigital")
        transc.setValue(makerCart, forKey: "makerCart")
        transc.setValue(aulaMaker, forKey: "aulaMaker")
        transc.setValue(proyector, forKey: "proyector")
        transc.setValue(telepresencia, forKey: "telepresencia")
        transc.setValue(aceleracon, forKey: "aceleracon")
        transc.setValue(certificacion, forKey: "certificacion")
        transc.setValue(desarrollo, forKey: "desarrollo")
        transc.setValue(vendedorId, forKey: "vendedorId")
        transc.setValue(Date(), forKey: "creationDate")
        transc.setValue(totalPuntos, forKey: "totalPuntos")
        transc.setValue(totalPesos, forKey: "totalPesos")
        transc.setValue(totalAnios, forKey: "totalAnios")
        transc.setValue(totalPesosExt, forKey: "totalPesosExt")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getProposals () -> NSArray{
        let fetchRequest: NSFetchRequest<Propuestas> = Propuestas.fetchRequest()
        var myProposals = [Propuesta]()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for trans in searchResults as [NSManagedObject] {
                let mPropuesta = Propuesta()
                mPropuesta.schoolId = trans.value(forKey: "schoolId") as! Int
                mPropuesta.schoolName = trans.value(forKey: "schoolName") as! String
                mPropuesta.cp = trans.value(forKey: "cp") as! Int
                mPropuesta.col = trans.value(forKey: "col") as! String
                mPropuesta.street = trans.value(forKey: "street") as! String
                mPropuesta.streetNo = trans.value(forKey: "streetNo") as! String
                mPropuesta.contactName = trans.value(forKey: "contactName") as! String
                mPropuesta.contactMail = trans.value(forKey: "contactMail") as! String
                mPropuesta.aulaDigital = trans.value(forKey: "aulaDigital") as! Int
                mPropuesta.makerCart = trans.value(forKey: "makerCart") as! Int
                mPropuesta.aulaMaker = trans.value(forKey: "aulaMaker") as! Int
                mPropuesta.proyector = trans.value(forKey: "proyector") as! Int
                mPropuesta.telepresencia = trans.value(forKey: "telepresencia") as! Int
                mPropuesta.aceleracon = trans.value(forKey: "aceleracon") as! Int
                mPropuesta.certificacion = trans.value(forKey: "certificacion") as! Int
                mPropuesta.desarrollo = trans.value(forKey: "desarrollo") as! Int
                mPropuesta.vendedorId = trans.value(forKey: "vendedorId") as! Int
                mPropuesta.creationDate = trans.value(forKey: "creationDate") as! Date
                mPropuesta.totalPuntos = trans.value(forKey: "totalPuntos") as! Int
                mPropuesta.totalPesos = trans.value(forKey: "totalPesos") as! Double
                mPropuesta.totalAnios = trans.value(forKey: "totalAnios") as! Int
                mPropuesta.totalPesosExt = trans.value(forKey: "totalPesosExt") as! Double
                
                myProposals.append(mPropuesta)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return myProposals as NSArray
    }
    
    func storeSchool (schoolId: Int, schoolName: String, puntosOfrecer: Int, data: String, renovacionKinder: Int, renovacionPrimaria:Int, renovacionSecundaria: Int) {
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Schools", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(schoolId, forKey: "schoolId")
        transc.setValue(schoolName, forKey: "schoolName")
        transc.setValue(puntosOfrecer, forKey: "puntosOfrecer")
        transc.setValue(renovacionKinder, forKey: "renovacionKinder")
        transc.setValue(renovacionPrimaria, forKey: "renovacionPrimaria")
        transc.setValue(renovacionSecundaria, forKey: "renovacionSecundaria")
        transc.setValue(data, forKey: "data")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getSchools () -> NSArray{
        let fetchRequest: NSFetchRequest<Schools> = Schools.fetchRequest()
        var mySchools = [Escuela]()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            for trans in searchResults as [NSManagedObject] {
                let mSchool = Escuela()
                let mySchoolId: Int = trans.value(forKey: "schoolId") as! Int
                mSchool.id = mySchoolId.description
                mSchool.nombre = trans.value(forKey: "schoolName") as! String
                mSchool.puntosOfrecer = trans.value(forKey: "puntosOfrecer") as! Int
                mSchool.renovacionKinder = trans.value(forKey: "renovacionKinder") as! Int
                mSchool.renovacionPrimaria = trans.value(forKey: "renovacionPrimaria") as! Int
                mSchool.renovacionSecundaria = trans.value(forKey: "renovacionSecundaria") as! Int
                mySchools.append(mSchool)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return mySchools as NSArray
    }
    
    func getTotalSchools () -> Int{
        let fetchRequest: NSFetchRequest<Schools> = Schools.fetchRequest()
        var totalSchools: Int = 0
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            totalSchools = searchResults.count
        } catch {
            print("Error with request: \(error)")
        }
        return totalSchools
    }
    
    func deleteAll(){
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Propuestas", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        context.delete(transc)
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }

}

