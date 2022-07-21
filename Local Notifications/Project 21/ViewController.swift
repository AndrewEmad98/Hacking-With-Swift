//
//  ViewController.swift
//  Project 21
//
//  Created by Andrew Emad on 20/07/2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal(scheduledDetector:)))
    }

    @objc func registerLocal() {
        let userNotification = UNUserNotificationCenter.current()
        userNotification.requestAuthorization(options: [.alert,.badge,.sound]){ (authGranted,error) in
            if authGranted {
                print("YAY!")
            }else{
                print("D'OH!")
            }
        }
    }

    @objc func scheduleLocal(scheduledDetector : Bool = false) {

        registerCategory()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger:UNTimeIntervalNotificationTrigger
        if scheduledDetector {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        }else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
    
        let content = UNMutableNotificationContent()
        content.title = "Title goes here"
        content.body = "Main text goes here"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategory(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let btn = UNNotificationAction(identifier: "Show", title: "Tell me more...", options: .foreground)
        let btn2 = UNNotificationAction(identifier: "Remaind", title: "Remaind me later!", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [btn,btn2], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let customData = response.notification.request.content.userInfo["customData"] as? String else {
            completionHandler()
            return
        }
        print("Custom data received: \(customData)")
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier :
            // the user swiped to unlock
            print("Default identifier")
        case "Show" :
            // the user tapped our "show more info…" button
            print("Show more information…")
        case "Remaind" :
            print("Remaind later")
            scheduleLocal(scheduledDetector: true)
        default :
            break
        }
        completionHandler()
    }
}

