//
//  SignUpViewController.swift
//  bigMother_iOS
//
//  Created by Aidan De Leon on 2019-11-22.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    var db:Firestore!
    
    var parentID: String = ""
    
    var childID : String = ""
    
    var childArray : [String] = []
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var parentSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
        statusLabel.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if segue.identifier == "loginSegue" {
                
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! SubjectViewController
            destinationViewController.parentID = parentID
            destinationViewController.subjects = childArray
            
            let nav2 = barViewControllers.viewControllers![2] as! UINavigationController
            let destinationViewController2 = nav2.viewControllers[0] as! SettingsTableViewController
//            destinationViewController2.subjects = childArray
            destinationViewController2.parentID = parentID


        }
        
        if segue.identifier == "childRoute" {
                 
            let barViewControllers = segue.destination as! UITabBarController
            let nav = barViewControllers.viewControllers![1] as! UINavigationController
            let destinationViewController2 = barViewControllers.viewControllers![0] as! ChildHomeViewController
            let destinationViewController = nav.viewControllers[0] as! ChildSettingsTableViewController
            destinationViewController.childID = self.childID
            destinationViewController2.childID = self.childID


         }

        
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        let usernameText = email.text
        let passwordText = password.text
        let confPasswordText = confirmPassword.text
        
                
        if passwordText != confPasswordText {
            statusLabel.text = "Passwords do not match."
            statusLabel.textColor = .red
            statusLabel.isHidden = false
            
        } else if usernameText == "" {
            statusLabel.text = "Please enter a username."
            statusLabel.textColor = .red
            statusLabel.isHidden = false
            
        } else if parentSwitch.isOn {
            
            self.parentID = usernameText!

        
               db.collection("parents").getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                          
                       } else {
                          
                           for document in querySnapshot!.documents {

                              if (document.documentID == usernameText) {
                                  self.statusLabel.text = "Username already taken."
                                  self.statusLabel.textColor = .red
                                  self.statusLabel.isHidden = false
                                  
                                  return

                               }
                          }

                          self.db.collection("parents").document(usernameText!).setData([
                              "password": passwordText!
                                  ]) { err in
                                      if let err = err {
                                          print("error creating channel")
                                      } else {
                                          print("parent created")

                                      }
                                  }



                          self.statusLabel.text = "Registered successfuly!"
                          self.statusLabel.textColor = .systemGreen
                          self.statusLabel.isHidden = false

                          self.performSegue(withIdentifier: "loginSegue", sender: nil)

                              
                           }
                      
                  }
            
            
        } else {
            
            self.childID = usernameText!

            db.collection("children").getDocuments() { (querySnapshot, err) in
                             if let err = err {
                                 print("Error getting documents: \(err)")
                                
                             } else {
                                
                                 for document in querySnapshot!.documents {

                                    if (document.documentID == usernameText) {
                                        self.statusLabel.text = "Username already taken."
                                        self.statusLabel.textColor = .red
                                        self.statusLabel.isHidden = false
                                        
                                        return

                                     }
                                }

                                self.db.collection("children").document(usernameText!).setData([
                                    "password": passwordText!
                                        ]) { err in
                                            if let err = err {
                                                print("error creating channel")
                                            } else {
                                                print("child created")

                                            }
                                        }



                                self.statusLabel.text = "Registered successfuly!"
                                self.statusLabel.textColor = .systemGreen
                                self.statusLabel.isHidden = false

                                self.performSegue(withIdentifier: "childRoute", sender: nil)

                                    
                                 }
                            
                        }
//            db.collection("children").getDocuments() { (querySnapshot, err) in
//                         if let err = err {
//                             print("Error getting documents: \(err)")
//
//                         } else {
//
//                             for document in querySnapshot!.documents {
//
//                                if (document.documentID == usernameText) {
//                                    self.statusLabel.text = "Username already taken."
//                                    self.statusLabel.textColor = .red
//                                    self.statusLabel.isHidden = false
//
//                                    return
//
//                                 }
//                            }
//
//                            self.db.collection("children").document(usernameText!).setData([
//                                "password": passwordText!
//                                    ]) { err in
//                                        if let err = err {
//                                            print("error creating channel")
//                                        } else {
//                                            print("child created")
//
//                                        }
//                            }
//
//
//
//                            self.statusLabel.text = "Registered successfuly!"
//                            self.statusLabel.textColor = .systemGreen
//                            self.statusLabel.isHidden = false
//
//                            //self.performSegue(withIdentifier: "childRoute", sender: nil)
//
//
//                             }
//
//                    }
            
        }
        
        
        
    }
    
    
    @IBAction func backToLogIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
