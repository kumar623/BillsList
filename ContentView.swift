//
//  ContentView.swift
//  movieRev
//
//  Created by Krishna on 11/01/23.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var billsFunctions = BillsFunctions()
   
        
    
    
    var body: some View {
        if  authModel.user == nil {
            
            TabView{
                
               
                LoginView()
                    .tabItem {
                        Label("Sign In",systemImage: "arrow.right.to.line")
                    }
                    .onAppear(perform: {
                        billsFunctions.resetBills()
                    })
                SignupView()
                    .onAppear(perform: {
                        billsFunctions.resetBills()
                    })
                    
                    .tabItem {
                        Label("Sign Up",systemImage: "person.badge.plus")
                        
                    }
                
                
            }.onAppear {
                authModel.listenToAuthState()
                
                }
        }
        else{
            
            TabView{
                HomeView()
                    .environmentObject(billsFunctions)
                    .tabItem {
                        Label("Home",systemImage: "house.fill")
                    }
                    .onAppear {
                        self.billsFunctions = BillsFunctions()
                    }
                    
                Dashboard()
                    .environmentObject(billsFunctions)
                   
                    .tabItem {
                        
                        Label("DashBoard",systemImage: "list.dash")
                    }
               
                Profile()
                    
                    .tabItem{
                        Label("Profile",systemImage: "person.crop.circle")
                    }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
