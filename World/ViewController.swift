//
//  ViewController.swift
//  World
//
//  Created by J. Lozano on 3/23/19.
//  Copyright © 2019 J. Lozano. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, CocoaMQTTDelegate {
    
    @IBOutlet weak var factsButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let transition = CircularTransition()
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        mqtt.connect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        mqtt.subscribe("topic/test")
        mqtt.didReceiveMessage = { mqtt, message, id in
            
            print("Message received in topic \(message.topic) with payload \(message.string!)")
            if message.string! == "Parts Unknown"{
                self.imageView.image = UIImage(named: "")
            } else {
                 self.imageView.image = UIImage(named: "\(message.string!)")
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    

    let mqtt = CocoaMQTT(clientID: "iOSDevice", host: "adapi.local", port: 1883)
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        mqtt.username = "test"
//        mqtt.password = "public"
        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.logLevel = .debug
        mqtt.keepAlive = 60
        mqtt.connect()
        mqtt.subscribe("topic/test")
        mqtt.delegate = self
        mqtt.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic \(message.topic) with payload \(message.string!)")
             self.imageView.image = UIImage(named: "\(message.string!)")
        }


    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let secondVC = segue.destination as! FactsViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
            
        }
      
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss

        return transition
    }

    
}
