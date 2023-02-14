//
//  UpcommingBills.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject private var userViewData: UserViewData
    @EnvironmentObject private var authModel: AuthViewModel
    
    
    
    var body: some View {
        
        NavigationView {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "AWrongURL")!) { phase in // 1
                            if let image = phase.image { // 2
                                // if the image is valid
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil { // 3
                                Image("defaultUserImage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                               
                              
                            } else {
                                //appears as placeholder image
                                Image(systemName: "photo") // 4
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }.frame(width: 250, height: 250, alignment: .center)

                Text(UserDefaults.standard.string(forKey: "Name") ?? "No Name")
                
            }
        }
        .navigationBarItems(trailing:Button("Sign Out") {
            authModel.signOut()
            
                    })
            
    }
        
        
    }
    
}

struct UpcommingBills_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
