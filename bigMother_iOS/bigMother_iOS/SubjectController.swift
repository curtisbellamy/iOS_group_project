//
//  TableViewController.swift
//  bigMother_iOS
//
//  Created by Yuanyuan Zhang on 2019-09-24.
//  Copyright © 2019 Curtis Bellamy. All rights reserved.
//

import UIKit
import FirebaseFirestore
import UserNotifications
import NotificationView


var myIndex = 0
class SubjectViewController: UITableViewController {
    
    var parentID : String = ""
        
    @IBOutlet weak var titleLabel: UILabel!
    
    var db:Firestore!
    
    var subjects : [String] = []
        
    var subjectChosen : String = ""

    var timer = Timer()
    
    var notified : Bool = false


    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        if subjects.count == 0 {
            titleLabel.text = "No subjects yet."
        }
        
        buildArray()
        self.tableView.reloadData()
        
        
//        checkReceivedStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        startNotificationTimer()

    }
    
    private func startNotificationTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:  #selector(self.checkReceivedStatus), userInfo: nil, repeats: true)

    }
    
    
    @objc func willResignActive(_ notification: Notification) {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:  #selector(self.checkReceivedStatus), userInfo: nil, repeats: true)
        print("BACKGROUND")
    }
    
    
    //FINISH
    @objc func checkReceivedStatus() {
        
        if notified {
            self.timer.invalidate()
            self.notified = false
        }
        
        let appState = UIApplication.shared.applicationState
        
        let docRef = self.db.collection("channels").document(parentID)
           docRef.getDocument { (document, error) in
                   
               if let document = document, document.exists {
                   
                for data in document.data()! {
                    print(data.key)
                    let tempArr = data.value as? Array<Any>
                    let last = tempArr![tempArr!.endIndex - 1] as! NSDictionary
                    let tempState = last.value(forKey: "state")
                    
                    if tempState as? String == "received" {
                        
                        if appState == .background {
                            
                            let center = UNUserNotificationCenter.current()
                    
                            center.requestAuthorization(options: [.alert, .sound])
                            { (granted, error) in
                    
                            }
                    
                            let content = UNMutableNotificationContent()
                            content.title = "Attention"
                            content.body = "You have received an update from \(data.key)!"
                    
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                            repeats: false)
                    
                            let uuidString = UUID().uuidString
                            let request =  UNNotificationRequest(identifier: uuidString, content:
                                content, trigger: trigger)
                    
                            center.add(request) { (error) in }
                            
                            self.notified = true
                            
                        }
                        
                        if appState == .active {
                            
                            let notificationView = NotificationView.default
                            notificationView.title = "Attention"
//                            notificationView.subtitle = "You have received an update from \(data.key)"
                            notificationView.body = "You have received an update from \(data.key)"
//                            notificationView.image = image
                            notificationView.show()
                            
                            self.notified = true
        
                            
                        }
                    }
                    print(last)
//                    print(tempArr!.value(forKey: "state"))
//                    var lastUpdate = array[array!.endIndex - 1] as! NSDictionary
//                    print(lastUpdate)

                }
//                   let thread = document.data()![self.replace(str: self.subjectName)] as? [NSDictionary]
//
//                   for update in thread! {
//
//                       if update.value(forKey: "state") as? String == "received" {
//                           self.history.append(update)
//                       }
//                   }

                   
                       

                   } else {
                       print("Document does not exist")
                   }
               }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           buildArray()
                             
           self.tableView.reloadData()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        buildArray()
                          
        self.tableView.reloadData()


    }
    
    
    func buildArray() {
          let docRef = db.collection("parents").document(parentID)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {

                  if let children = document.data()?["children"] {
                        self.subjects = children as! [String]

                    }
                } else {
                    print("Document does not exist")
                }
            }
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SubjectDetailsViewController
        destination.subjectName = subjectChosen
        destination.parentID = parentID
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = subjects[indexPath.row]
        
        let img = UIImageView(image:UIImage(named:"alert-1")!)
        img.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        cell.accessoryView = img
        
//        img.isHidden = true
        cell.accessoryView?.isHidden = true

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        subjectChosen = subjects[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
    }

}
