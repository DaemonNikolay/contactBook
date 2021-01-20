//
//  AppDelegate.swift
//  ContactBook
//
//  Created by Nikulux on 20.01.2021.
//

import UIKit

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
}
