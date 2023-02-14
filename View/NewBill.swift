//
//  NewBill.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import SwiftUI
import Firebase

struct NewBill: View {
    
    @EnvironmentObject private var billsFunctions: BillsFunctions
    @EnvironmentObject  var userViewData: UserViewData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var BillCategory = Types.Loan
    @State private var monthlyAmount = 0.0
    @State private var startDate = Date()
    @State private var endDate =  Calendar.current.date(from: DateComponents(year: 2030, month: 01, day: 01))!
    @State private var paymentType = PaymentTypes.Monthly
    @State private var msg = ""
   
    
    
    
    @State private var triggerError = false
    @State private var startDateExpanded = false
    @State private var endDateExpanded = false
    @State private var RepeatEveryExpanded = true
    @State private var Repeatforever = true
    

    
    @State private var selectedRepeat = "Month"
    let timePeriods = ["Day", "Week", "Month","Year"]
    
    enum Types: String, CaseIterable {
        case Loan = "Loan"
        case Mobile = "Mobile"
        case WiFi = "WiFi"
        case CreditCard = "Credit Card"
        case Personal = "Personal"
        case Subscription
    }

    enum PaymentTypes: String, CaseIterable {
        case Daily = "Daily"
        case Weekly = "Weekly"
        case Monthly = "Monthly"
        case Yearly = "Yearly"
    }
    
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Bill Details")) {
                    
                    TextField("Name", text: $name)
                    
                    Picker("Payment Type", selection: $BillCategory) {
                        ForEach(Types.allCases, id: \.self) { types in
                            Text(types.rawValue).tag(types)
                        }
                    }

                  
                   
                    
                    TextField("Monthly Amount", value: $monthlyAmount, format: .number)
                        .textFieldStyle(.roundedBorder)
                     
                    DisclosureGroup("Start Date",isExpanded: $startDateExpanded){
                        DatePicker(" ", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    DisclosureGroup("Recurring",isExpanded: $RepeatEveryExpanded){
                        Picker("Recurring", selection: $paymentType) {
                            ForEach(PaymentTypes.allCases, id: \.self) { types in
                                Text(types.rawValue).tag(types)
                            }
                        }.pickerStyle(.segmented)
                    }
                        
                   
                        
                        
                    
                    Toggle("Repeat Forever", isOn: $Repeatforever)
                    if !Repeatforever{
                        DisclosureGroup("End Date",isExpanded: $endDateExpanded){
                            DatePicker ("", selection: $endDate, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                        }
                    }
                    
                        
                        
                    }
                  

                }
            
            Button {
                
                if name.count < 2 {
                    self.msg = "name should not be empty or less then 2 words"
                    triggerError.toggle()
                    
                }
                else if  monthlyAmount == 0.0{
                    self.msg = "Monthly amount  should not be empty or 0"
                    triggerError.toggle()
                }
                else{
                    let data: [String: Any] = [
                      "Name": name,
                      "BillCategory": BillCategory.rawValue,
                      "MonthlyAmount": monthlyAmount,
                      "startDate": startDate,
                      "endDate": Repeatforever ?  Calendar.current.date(from: DateComponents(year: 2040, month: 01, day: 01))! : endDate  ,
                      "PaymentType": paymentType.rawValue
                    ]
                    userViewData.addData(data: data)
                    presentationMode.wrappedValue.dismiss()
                    
                
                    
                    
                    
                    
            
                }
                
            } label: {
                Text("Save")
            }
            .alert(msg, isPresented: $triggerError) {
                Button("okay") {
                    triggerError.toggle()
                }
            }
        }
    }
}
struct NewBill_Previews: PreviewProvider {
    static var previews: some View {
        NewBill()
    }
}
