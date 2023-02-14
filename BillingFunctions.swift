//
//  BillingFunctions.swift
//  movieRev
//
//  Created by Krishna on 10/02/23.
//

import Foundation
import Firebase
import SwiftUI

class BillsFunctions:ObservableObject {
    
    @Published var bills: [Bill] = []
    @Published var userDetails = UserDetails(name: "", uid: "", email: "")
    
    let uid = Auth.auth().currentUser?.uid
    private var db = Firestore.firestore()
    
    init() {
        if (Auth.auth().currentUser?.uid) != nil{
            self.fetchData { (bills) in
                self.bills = bills
                
            }
            
            
        }
        gettingUserDetails()
    }
    
    func fetchData(completion: @escaping ([Bill]) -> Void) {
        var fetchedBills: [Bill] = []
        guard let uid = uid else { return }
        let path = "/users/\(uid)/paymentData"
        db.collection(path).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in querySnapshot!.documents {
                    let data: [String: Any] = [
                        "ID":document.documentID ,
                        "Name": document.get("Name") as! String,
                        "Type": document.get("BillCategory")as! String,
                        "MonthlyAmount": document.get("MonthlyAmount") as! Double,
                        "startDate": (document.get("startDate") as! Timestamp).dateValue(),
                        "endDate": (document.get("endDate")as! Timestamp ).dateValue(),
                        "PaymentType": document.get("PaymentType") as! String
                    ]
                    
                    let bill = (Bill(id:data["ID"] as? String ,name: data["Name"] as! String , typeOfBill: data["Type"] as! String, MonthlyAmount: data["MonthlyAmount"] as! Double, startDate: data["startDate"] as! Date, EndDate:data["endDate"] as! Date , PaymentType: data["PaymentType"] as! String))
                    
                    fetchedBills.append(bill)
                }
                completion(fetchedBills)
            }
        }
    }
    
    func gettingUserDetails(){
        let db = Firestore.firestore()
        let usersRef = db.collection("/users")

        usersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    UserDefaults.standard.set(document.get("Name") as! String, forKey: "Name")
                    UserDefaults.standard.set(document.get("email") as! String, forKey: "email")
                    UserDefaults.standard.set(document.get("Uid") as! String, forKey: "Uid")
                           }
            }
        }
        
    }
        
        func next7DaysBill() -> [Bill] {
            let calendar = Calendar.current
            let today = Date()
            
            let SevenDaysFromToday = calendar.date(byAdding: .day, value: 7, to: today)!
            let sevendaysRange = today...SevenDaysFromToday
            var next7DaysBills: [Bill] = []
            
            for bill in bills {
                if bill.PaymentType == "Weekly" {
                    let Day = calendar.component(.weekday, from: bill.startDate)
                    //getting the day for billstart date
                    var nextBillDate = calendar.nextDate(after: today, matching: .init(weekday: Day), matchingPolicy: .nextTime)
                    
                    while nextBillDate! <= SevenDaysFromToday {
                        
                        next7DaysBills.append(Bill(id: UUID().uuidString, name: bill.name, typeOfBill: bill.typeOfBill, MonthlyAmount: bill.MonthlyAmount, startDate: bill.startDate, EndDate: bill.EndDate, PaymentType: bill.PaymentType, DateOfPayment: nextBillDate))
                        
                        nextBillDate = calendar.nextDate(after: nextBillDate!, matching: .init(weekday: Day), matchingPolicy: .nextTime)
                    }
                }
                if bill.PaymentType == "Monthly" {
                    let numberOfMonths = Calendar.current.dateComponents([.month], from: bill.startDate, to: today).month! + 1
                    let nextBillDate = calendar.date(byAdding: .month, value: numberOfMonths, to: bill.startDate)!
                    
                    next7DaysBills.append(Bill(id: UUID().uuidString, name: bill.name, typeOfBill: bill.typeOfBill, MonthlyAmount: bill.MonthlyAmount, startDate: bill.startDate, EndDate: bill.EndDate, PaymentType: bill.PaymentType, DateOfPayment: nextBillDate))
                    
                }
                
                
                
                
            }
            return next7DaysBills.filter({sevendaysRange.contains($0.DateOfPayment!)}).sorted{ $0.DateOfPayment! < $1.DateOfPayment! }
            
            
        }
        
        
        func next30DaysBill() -> [Bill] {
            let calendar = Calendar.current
            let today = Date()
            
            let thirtyDaysFromToday = calendar.date(byAdding: .day, value: 30, to: today)!
            let SevenDaysFromToday = calendar.date(byAdding: .day, value: 7, to: today)!
            
            let sevendaysRange = today...SevenDaysFromToday
            var next30DaysBills: [Bill] = []
            
            for bill in bills {
                if bill.PaymentType == "Weekly" {
                    let Day = calendar.component(.weekday, from: bill.startDate)
                    //getting the day for billstart date
                    var nextBillDate = calendar.nextDate(after: today, matching: .init(weekday: Day), matchingPolicy: .nextTime)
                    
                    while nextBillDate! <= thirtyDaysFromToday {
                        
                        next30DaysBills.append(Bill(id: UUID().uuidString, name: bill.name, typeOfBill: bill.typeOfBill, MonthlyAmount: bill.MonthlyAmount, startDate: bill.startDate, EndDate: bill.EndDate, PaymentType: bill.PaymentType, DateOfPayment: nextBillDate))
                        
                        nextBillDate = calendar.nextDate(after: nextBillDate!, matching: .init(weekday: Day), matchingPolicy: .nextTime)
                    }
                }
                if bill.PaymentType == "Monthly" {
                    let numberOfMonths = Calendar.current.dateComponents([.month], from: bill.startDate, to: today).month! + 1
                    let nextBillDate = calendar.date(byAdding: .month, value: numberOfMonths, to: bill.startDate)!
                    
                    next30DaysBills.append(Bill(id: UUID().uuidString, name: bill.name, typeOfBill: bill.typeOfBill, MonthlyAmount: bill.MonthlyAmount, startDate: bill.startDate, EndDate: bill.EndDate, PaymentType: bill.PaymentType, DateOfPayment: nextBillDate))
                    
                }
                
                
            }
            
            return next30DaysBills.filter({!sevendaysRange.contains($0.DateOfPayment!)}).sorted{ $0.DateOfPayment! < $1.DateOfPayment! }
        }
        
        
        
        
        func findingWeekdays(date:Date)->String{
            
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            
            switch weekday {
            case 1:
                return("Sunday")
            case 2:
                return("Monday")
            case 3:
                return("Tuesday")
            case 4:
                return("Wednesday")
            case 5:
                return("Thursday")
            case 6:
                return("Friday")
            case 7:
                return("Saturday")
            default:
                return("Invalid weekday")
            }
            
            
            
        }
        func sumOfPayments(bills:[Bill]) -> Double {
            let total = bills.reduce(0.0) { (result, bill) -> Double in
                return result + bill.MonthlyAmount
            }
            return total
        }
        
        func resetBills() {
            self.bills = []
        }
        
        
        
        
        
        
        
        
    }
    
    

