//
//  BillRowView.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import SwiftUI

struct BillRowView: View {
    var bil : Bill
    
    var body: some View {
        VStack{
            
            HStack{
                if let bill = bil.DateOfPayment {
                    VStack{
                        Text(bill.formatted(.dateTime.weekday(.wide)))
                            .font(.title3)
                        Text(bill.formatted(.dateTime.day().month()))
                            .font(.title3)
                        
                    }
                    
                    
                    
                }
                Text(bil.name)
                    .font(.title)
                    .padding(.trailing)
                    
                Spacer()
                Text(String(format: "%.1f", (bil.MonthlyAmount)))
            }.padding(4)
            HStack{
                if (bil.DateOfPayment == nil) {
                    Text(bil.typeOfBill)
                    Spacer()
                    Text(bil.PaymentType)
                }
                
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
        }
       
            
        .background(LinearGradient(colors: [.blue,.cyan], startPoint: .trailing, endPoint: .leading))
            .cornerRadius(5)
          
        
    }
}
struct BillRowView_Previews: PreviewProvider {
    static var previews: some View {
        BillRowView(bil: Bill(name: "Name", typeOfBill: "type", MonthlyAmount: Double(23) ,startDate: Date(), EndDate: Date(), PaymentType: "paymentType" ))
        
    }
}
