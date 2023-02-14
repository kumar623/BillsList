//
//  LoginView.swift
//  movieRev
//
//  Created by Krishna on 11/01/23.
//
import SwiftUI
import Firebase
struct LoginView: View {
    
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @State private var email: String = "krishna@gmail.com"
    @State private var password: String = "123456"
    @State private var StatusMessage : String = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(hex: "#B2FEFA"),Color(hex: "#0ED2F7")], startPoint: .top, endPoint: UnitPoint.bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("Welcome Back!")
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
                
                Button(action: {
                    authModel.signIn(emailAddress: email, password: password)
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                }
                .padding()
                
            }
        }
        
    }
    
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}
