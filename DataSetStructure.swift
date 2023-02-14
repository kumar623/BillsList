//
//  DataSetStructure.swift
//  movieRev
//
//  Created by Krishna on 16/01/23.
//

import Foundation






struct Bill :Identifiable{
    var  id: String?
    var name : String
    var typeOfBill: String
    var MonthlyAmount : Double
    var startDate : Date
    var EndDate : Date
    var PaymentType : String
    var DateOfPayment:Date?
    
}
struct UserDetails {
    var name : String
    var uid : String
    var email : String
}

    










