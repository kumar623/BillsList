//
//  HomeView.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var billsFunctions: BillsFunctions
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var userViewData : UserViewData
    
    @State private var isNewBillViewVisible = false
    var body: some View {
        NavigationView{
        ZStack{
            LinearGradient(colors: [Color(hex: "#B2FEFA"),Color(hex: "#0ED2F7")], startPoint: .top, endPoint: UnitPoint.bottom)
                .ignoresSafeArea()
           
                HStack{
                    ScrollView{
                        VStack{
                            
                            Text("Next 7 Days Bills")
                            
                                
                            
                            ForEach(billsFunctions.next7DaysBill()) { bill in
                                BillRowView(bil: bill).padding(5)
                            }
                            Text("Next 30 days bills")
//                            Text(String(format: "%.1f", (billsFunctions().sumOfPayments(bills: billsFunctions().next30DaysBill(bills: userViewData.bills)))))
                            ForEach(billsFunctions.next30DaysBill()) { bill in
                                BillRowView(bil: bill).padding(5)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
