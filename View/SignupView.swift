//
//  SignupView.swift
//  movieRev
//
//  Created by Krishna on 11/01/23.
//

import SwiftUI
import Firebase
struct SignupView: View {
    
   
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @State private var email: String = "krishna@gmail.com"
    @State private var password: String = "123456"
    @State private var confirmPassword: String = "123456"
    @State private var name: String = "Krishna"
    @State private var showError: Bool = false
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(colors: [Color(hex: "#B2FEFA"),Color(hex: "#0ED2F7")], startPoint: .top, endPoint: UnitPoint.bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("Create an account")
                    .font(.title)
                    .padding()
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)
                
                if(showError) {
                    Text("Passwords don't match")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if(self.password != self.confirmPassword) {
                        self.showError = true
                    } else {
                        
                        self.showError = false
                        authModel.signUp(emailAddress: email, password: password)
                    }
                    
                    
                    
                }) {
                    Text("Signup")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                }
                
                .padding()
            }
        }
        
        
        
    }
    
    
    
    private func storeUserInformationSignUP () {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userData = ["Name" : self.name,"email" : self.email,"Uid": uid]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData){ err in
                if let err = err {
                    print(err)
                    return
                }
                print("success")
            }
      
    }
}
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
