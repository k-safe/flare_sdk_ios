//
//  ViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine

class StandardThemeViewController: UIViewController {
    
    let sideEngineShared = BBSideEngineManager.shared
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var riderName: UITextField!
    @IBOutlet weak var riderEmail: UITextField!
    @IBOutlet var startButton : UIButton!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.confidenceLabel.text = ""
        self.startButton.tag = 1
        
        //Configure SIDE engine and register listner
        self.sideEngineConfigure()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure() {
        let shared = BBSideEngineManager.shared
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
        let mode: BBMode = isProductionMode ? .production : .sandbox
        let accessKey = isProductionMode ? "Your production license key here" : "Your sandbox license key here"
        shared.configure(accessKey: accessKey, mode: mode, theme: .standard)
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
    }
    
    
    @IBAction func startPressed(button : UIButton) {
        //Start and Stop SIDE engine
        if self.startButton.tag == 1 {
            sideEngineShared.riderName = riderName.text! //Rider Name (optional)
            sideEngineShared.riderEmail = riderEmail.text! // Rider Email (optional)
            sideEngineShared.riderId = self.uniqueId() // Unique rider ID (optional)
            sideEngineShared.countDownDuration = 30 // for live mode
            sideEngineShared.showLog = true //Default true //false when release app to the store
            
            //The "enableVRUUpdates" feature is a safety measure designed for cyclists, which allows them to send notifications to nearby fleet users.
            sideEngineShared.enable_flare_aware_network = true
            
            //It is possible to activate the distance filter in order to transmit location data in the live tracking URL. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
            sideEngineShared.distance_filter_meters = 20
            
            //The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
            sideEngineShared.low_frequency_intervals_seconds = 15
            
            //The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
            sideEngineShared.high_frequency_intervals_seconds = 3
            
            //It is recommended to activate the high frequency mode when the SOS function is engaged in order to enhance the quality of the live tracking experience.
            sideEngineShared.high_frequency_mode_enabled = false
            
            //You can update below parameters if require
            //sideEngineShared.backgroundColor = UIColor //Only for standard theme
            //sideEngineShared.contentTextColor = UIColor //Only for standard theme
            //sideEngineShared.swipeToCancelTextColor = UIColor //Only for standard theme
            //sideEngineShared.swipeToCancelBackgroundColor = UIColor //Only for standard theme
            //sideEngineShared.impactBody = "Detected a potential fall or impact involving" //This message show in the SMS, email, webook and slack body with the rider name passed in the section:7 (shared.riderName) parameter
            
            
            //Start SIDE engine
            sideEngineShared.startSideEngine()
           
        } else {
            //stopSideEngine will stop all the services inside SIDE engine and release all the varibales
            self.sideEngineShared.stopSideEngine()
        }
        
    }
    
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        sideEngineShared.sideEventsListener { (response) in
            //This call back basiclly where you call the configure method
            if response.type == .configure && response.success == true {
                //You are now able to initiate the SIDE engine process at any time. In the event that there is no user input button available to commence the activity, you may commence the SIDE engine by executing the following command:
                print("CONFIGURE with status: \(String(describing: response.success))")
            }
            else if response.type == .start {
                //Update your UI here (e.g. update START button color or text here when SIDE engine started)
                print("START live mode with status: \(String(describing: response.success))")
                
                if response.success == true {
                    self.startButton.tag = 2
                    self.startButton.setTitle("STOP", for: .normal)
                    self.startButton.backgroundColor = .red
                } else {
                    //Handle error message here
                    print("Error message: \(String(describing: response.payload))")
                }
            }
            else if response.type == .stop && response.success == true {
                //Update your UI here (e.g. update STOP button color or text here when SIDE engine stopped)
                print("STOP live mode with status: \(String(describing: response.success))")
                self.startButton.tag = 1
                self.startButton.setTitle("START", for: .normal)
                self.startButton.backgroundColor = .systemGreen
                
            }
            else if response.type == .incidentDetected {
                
                //The user has identified an incident, and if necessary, it may be appropriate to log the incident in either the analytics system or an external database. Please refrain from invoking any side engine methods at this juncture.
                
                if self.isProductionMode == true {
                    if let confidence = response.payload?["confidence"] {
                        print("SIDE engine confidence is: \(confidence)")
                        self.confidenceLabel.text = "SIDE confidence is: \(confidence)"
                    }
                } else {
                    //Test mode not return confidence
                    self.confidenceLabel.text = ""
                }
            }
            else if response.type == .incidentCancel {
                //The incident has been automatically cancelled. If necessary, you may log the incident in the analytics system. Please refrain from invoking any side engine methods at this juncture.
            }
            else if response.type == .timerStarted {
                //A 30-second countdown timer has started, and the SIDE engine is waiting for a response from the user or an automatic cancellation event. If no events are received within the 30-second intervals of the timer, the SIDE engine will log the incident on the dashboard.
            }
            else if response.type == .timerFinished {
                //After the 30-second timer ended, the SIDE engine began the process of registering the incident on the dashboard and sending notifications to emergency contacts.
                self.sendSMS()
                self.sendEmail()
            }else if response.type == .incidentAutoCancel {
                //The incident has been automatically cancelled. If necessary, you may log the incident in the analytics system. Please refrain from invoking any side engine methods at this juncture.
            }
            else if response.type == .incidentAlertSent {
                //Return the alert sent (returns alert details (i.e. time, location, recipient, success/failure))
            }
            else if response.type == .sms {
                //Returns SMS delivery status and response payload
            }else if response.type == .email {
                //Returns email delivery status and response payload
            }else if response.type == .location {
                //You will receive the user's location update status in this location. The payload contains a CLLocation object, which allows you to read any parameters if necessary.
            }else if response.type == .openVideoSurvey {
                //In the event that your partner has set up a video survey of the user following an incident detection, you will be notified of an "open video survey" event when the user accesses the survey page. It is unnecessary to invoke any SIDE engine functions in this context.
            }else if response.type == .closeVideoSurvey {
                //The user has submitted a video survey regarding the types of incidents that occur. you may log the survey event in the analytics system
            }else if response.type == .incidentVerifiedByUser {
                //The user has confirmed that the incident is accurate, therefore you may transmit the corresponding events to analytics, if needed. There is no requirement to invoke any functions from either party in this context, as the engine on the side will handle the task automatically.
            }else if response.type == .resumeSideEngine {
                //The user has confirmed that the incident is accurate, therefore you may transmit the corresponding events to analytics, if needed. There is no requirement to invoke any functions from either party in this context, as the engine on the side will handle the task automatically.
            }
        }
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
    
    func sendEmail() {
        if self.riderEmail.text?.isEmpty == false {
            BBSideEngineManager.shared.sendEmail(toEmail: self.riderEmail.text!)
        }
    }
    
    //Generate random uniqueID
    func uniqueId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    
}

