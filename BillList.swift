//
//  movieRevApp.swift
//  movieRev
//
//  Created by Krishna on 11/01/23.
//

import SwiftUI
import Firebase



@main
struct BillList: App {
    
    
    init (){
        FirebaseApp.configure()
  
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                
                .environmentObject(AuthViewModel())
                
                
               
        }
    }
}
class AppDelpgate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? =
                     nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
