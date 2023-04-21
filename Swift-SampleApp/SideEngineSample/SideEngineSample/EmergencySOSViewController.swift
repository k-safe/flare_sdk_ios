//
//  EmergencySOSViewController.swift
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/04/23.
//

import UIKit
import BBSideEngine

class EmergencySOSViewController: UIViewController {
    
    let sideEngineShared = BBSideEngineManager.shared
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var riderName: UITextField!
    @IBOutlet weak var riderEmail: UITextField!
    var shareLink = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btnShare.isHidden = true
        self.btnActivate.tag = 1
        self.sideEngineConfigure()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure() {

        
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
//        let accessKey = isProductionMode ? "Your production license key here" : "Your sandbox license key here"
        let mode: BBMode = isProductionMode ? .production : .sandbox
        let accessKey = isProductionMode ? "a6628abe-aa88-47fc-b3a8-6bbb702c44c5" : "c8d1aa40-ecdc-4d39-82bb-7e06aed534d1"
        sideEngineShared.configure(accessKey: accessKey, mode: mode, theme: .standard)

        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()

    }
    @IBAction func btnSOSAction(_ sender: Any) {
        
        if self.btnActivate.tag == 1 {
            sideEngineShared.riderName = riderName.text! //Rider Name (optional)
            sideEngineShared.riderEmail = riderEmail.text! // Rider Email (optional)
            sideEngineShared.riderId = self.uniqueId() // Unique rider ID (optional)
            sideEngineShared.countDownDuration = 30 // for live mode
            sideEngineShared.showLog = true //Default true //false when release app to the store
         
            
            //It is possible to activate the distance filter in order to transmit location data in the live tracking URL. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
            sideEngineShared.distance_filter_meters = 20
            
            //The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
            sideEngineShared.low_frequency_intervals_seconds = 15
            
            //The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
            sideEngineShared.high_frequency_intervals_seconds = 3
            
            //It is recommended to activate the high frequency mode when the SOS function is engaged in order to enhance the quality of the live tracking experience.
            sideEngineShared.high_frequency_mode_enabled = true
            
            
            BBSideEngineManager.shared.activeSOS()
        }else {
            BBSideEngineManager.shared.deActiveSOS()
        }
        
        
//        if BBSideEngineManager.shared.isSOSEnded == true{
//
//        }else{
//            BBSideEngineManager.shared.deActiveSOS()
//
//         }
    }
    
    
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        sideEngineShared.sideEventsListener { (response) in

              //This call back basiclly where you call the configure method
            if response.type == .configure && response.success == true {
                //Now you can ready to start SIDE engine process, if you dont have user input button to start activity then you can start SIDE engine here: sideEngineShared.startSideEngine(mode: .live)
                print("CONFIGURE with status: \(String(describing: response.success))")
            }
              else if response.type == .start {
                  //Update your UI here (e.g. update START button color or text here when SIDE engine started)
                  print("START live mode with status: \(String(describing: response.success))")
       
              }
              else if response.type == .stop && response.success == true {
                  //Update your UI here (e.g. update STOP button color or text here when SIDE engine stopped)
                  print("STOP live mode with status: \(String(describing: response.success))")
              }
              else if response.type == .incidentDetected {
                  print("INCIDENT DETECTED with status: \(String(describing: response.success))")
                  //Threshold reached and you will redirect to countdown page
                  //Return incident status and confidence level, you can fetch confidance using the below code:
                  if self.isProductionMode == true {
                      if let confidence = response.payload?["confidence"] {
                          print("SIDE engine confidence is: \(confidence)")
                       }
                  } else {
                      //Test mode not return confidence
                   }
                  
                  //Send SMS or Email code here to notify your emergency contact (Github example for sample code)
//                  self.sendSMS()
//                  if self.riderEmail.text?.isEmpty == false {
//                      self.sideEngineShared.sendEmail(toEmail: self.riderEmail.text!)
//                  }
              }
              else if response.type == .incidentCancel {
                   //User canceled countdown countdown to get event here, this called only if you configured standard theme.
              }
              else if response.type == .timerStarted {
                   //Countdown timer started after breach delay, this called only if you configured standard theme.
              }
              else if response.type == .timerFinished {
                   //Countdown timer finished and jump to the incident summary page, this called only if you configured standard theme.
              }
              else if response.type == .incidentAlertSent {
                   //Return the alert sent (returns alert details (i.e. time, location, recipient, success/failure))
              }
              else if response.type == .sms {
                   //Returns SMS delivery status and response payload
              }else if response.type == .email {
                   //Returns email delivery status and response payload
              }else if response.type == .location {
                  //Returns CLLocation object
             }else if response.type == .sosActive && response.success == true {
                 //Returns link in response payload
                  DispatchQueue.main.async {
                      self.btnShare.isHidden = false
                      self.btnActivate.tag = 2
                      
                      if let sosLiveTrackingUrl = response.payload?["sosLiveTrackingUrl"] as? String{
                          print("Tracking URL:",sosLiveTrackingUrl)
                          self.shareLink = sosLiveTrackingUrl
                          self.btnActivate.setTitle("DEACTIVATE SOS", for: .normal)
                          self.btnActivate.backgroundColor = .systemRed
                      }
                 }
              }else if response.type == .sosDeActive && response.success == true {
                  print("SOS DeActivated")
                //Returns link in response payload
                DispatchQueue.main.async {
                    self.btnActivate.tag = 1
                    self.btnShare.isHidden = true
                    self.btnActivate.setTitle("ACTIVATE SOS", for: .normal)
                    self.btnActivate.backgroundColor = .systemGreen
                }
             }
          }
    }
    
   
    
    //Generate random uniqueID
    @IBAction func btnShare(_ sender: Any) {
        let url = URL(string: self.shareLink)!
        let text = "SOS Live track link"

        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }

        self.present(activityViewController, animated: true, completion: nil)

    }
    
    func sendSMS() {
        if countryCode.text?.isEmpty == false && self.phoneNumber.text?.isEmpty == false {
            let contact = [
                "countryCode": String(countryCode.text!),
                "phoneNumber": String(phoneNumber.text!),
                "username": String(riderName.text!)
            ]
            
            BBSideEngineManager.shared.sendSMS(contact: contact)
        }
        
    }
    
    //Generate random uniqueID
    func uniqueId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
   
    
}
