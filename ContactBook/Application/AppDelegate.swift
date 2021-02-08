//
//  AppDelegate.swift
//  ContactBook
//
//  Created by Nikulux on 20.01.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
		
		beginUserStory()
		
		return true
	} 
	
	// MARK: - Private methods
	
	private func beginUserStory() {
		AppRouter().showSplash()
	}
	
	// MARK: - CoreData
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ContactDB")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
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
}
