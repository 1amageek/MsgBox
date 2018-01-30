//
//  AppDelegate.swift
//  Sample
//
//  Created by 1amageek on 2018/01/17.
//  Copyright © 2018年 Stamp Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSSetUncaughtExceptionHandler { exception in
            debugPrint(exception.name)
            debugPrint(exception.reason ?? "")
            debugPrint(exception.callStackSymbols)
        }

        FirebaseApp.configure()
//        let settings: FirestoreSettings = FirestoreSettings()
//        settings.isPersistenceEnabled = true
//        Firestore.firestore().settings = settings

        let user: User = User(id: "hoge")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MsgBox<Sample.Thread, Sample.Sender, Sample.Message>.viewController(userID: "hoge")
        self.window?.makeKeyAndVisible()

        return true
    }
}


