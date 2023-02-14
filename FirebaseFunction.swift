//
//  FirebaseFunction.swift
//  movieRev
//
//  Created by Krishna on 29/01/23.
//

import Foundation
import Firebase


final class AuthViewModel: ObservableObject {
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
        }
    }
    
    func signUp(
        emailAddress: String,
        password: String
    ) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("an error occured: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            
           
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func signIn(emailAddress: String,
                password: String){
    
        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("an error occured: \(error.localizedDescription)")
                return
            }
            if error == nil{
                
            }
          

            
            
        }
    }
}

class  UserViewData: ObservableObject{
    
    
    
    @Published var userData  = [UserDetails] ()
    
    
    
    let uid = Auth.auth().currentUser?.uid
    private var db = Firestore.firestore()
    
    func fetchData() -> [Bill] {
        
        var bills: [Bill] = []
        let uid = Auth.auth().currentUser?.uid
        let path = "/users/\(String(describing: uid))/paymentData"
        
        db.collection(path).getDocuments {  (querySnapshot, err) in
            if err != nil {
                print(err ?? "Error")
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
                  
                    bills.append(Bill(id:data["ID"] as? String ,name: data["Name"] as! String , typeOfBill: data["Type"] as! String, MonthlyAmount: data["MonthlyAmount"] as! Double, startDate: data["startDate"] as! Date, EndDate:data["endDate"] as! Date , PaymentType: data["PaymentType"] as! String))
                    
                   
                }
                
            }
        }
        return bills
    }
    
    func addData(data: [String:Any]) {
        
        if let uid = Auth.auth().currentUser?.uid{
            
            Firestore.firestore().collection("/users/\(uid)/paymentData").addDocument(data: data)
            
            
            
        }
        else {
            
            print("Error: No user logged in.")
            
            return
            
        }
    }
    
    
    func deleteBill(bill: Bill) {
       
        
        if let uid = Auth.auth().currentUser?.uid{
            let path = "/users/\(uid)/paymentData"
            let documentRef = db.collection(path).document(bill.id!)
            
            documentRef.delete() { error in
                if let error = error {
                    print("Error removing bill: \(error)")
                    return
                }
                print("Bill successfully removed!")
                
            }
        }
        
    }
}
