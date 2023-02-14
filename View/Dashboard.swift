//
//  Dashboard.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import SwiftUI
import Firebase
import SwiftUI_Color_Hex






struct Dashboard: View {
    @EnvironmentObject private var billsFunctions: BillsFunctions
    @EnvironmentObject private var authModel: AuthViewModel
    private var userViewData = UserViewData()
    
    
    @State private var isNewBillViewVisible = false
   
    
    var body: some View {
        
        NavigationView {
            ZStack{
                LinearGradient(colors: [Color(hex: "#7F7FD5"),Color(hex: "#91EAE4")], startPoint: .top, endPoint: UnitPoint.bottom)
                    .ignoresSafeArea()
                HStack{
                    List {
                        ForEach(billsFunctions.bills) { section in
                          BillRowView(bil: section)
                        }
                        .onDelete { index in
                            index.forEach { int in
                                userViewData.deleteBill(bill: billsFunctions.bills[int])
                            }
                      
                        }
                    }
                }
                
                
            }.navigationBarItems(trailing:Button("New Bill") {
                isNewBillViewVisible = true
            })
        }
        .sheet(isPresented: $isNewBillViewVisible,onDismiss: {
            isNewBillViewVisible = false
        }) {
            NewBill().environmentObject(userViewData)
        }
    }
   
       
}


struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
