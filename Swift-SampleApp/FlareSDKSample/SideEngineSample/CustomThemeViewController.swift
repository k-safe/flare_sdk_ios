//
//  ViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine

class CustomThemeViewController: UIViewController {
    
    let sideEngineShared = BBSideEngineManager.shared
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var riderName: UITextField!
    @IBOutlet weak var riderEmail: UITextField!
    @IBOutlet var startButton : UIButton!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    let customUIController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "CustomCountDownViewController") as! CustomCountDownViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confidenceLabel.text = ""
        self.startButton.tag = 1
        
        self.customUIController.delegate = self //This will used to send sms or email when countdown finished
        
        //Configure SIDE engine and register listner
        self.sideEngineConfigure()
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure() {
        let shared = BBSideEngineManager.shared
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
        let mode: BBMode = isProductionMode ? .production : .sandbox
        let accessKey = isProductionMode ? "Your production license key here" : "Your sandbox license key here"
        shared.configure(accessKey: accessKey, mode: mode, theme: .custom)
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    //TODO: SIDE engine live mode
    @IBAction func startPressed(button : UIButton) {
        //Start and Stop SIDE engine
        if self.startButton.tag == 1 {
            sideEngineShared.riderName = riderName.text! //Rider Name (optional)
            sideEngineShared.riderEmail = riderEmail.text! // Rider Email (optional)
            sideEngineShared.riderId = self.uniqueId() // Unique rider ID (optional)
            sideEngineShared.countDownDuration = 30 // for live mode
            sideEngineShared.showLog = true //Default true //false when release app to the store
            
            //The "enable_flare_aware_network" feature is a safety measure designed for cyclists, which allows them to send notifications to nearby fleet users.
            sideEngineShared.enable_flare_aware_network = true //(Optional)
            
            //It is possible to activate the distance filter in order to transmit location data in the live tracking URL. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
            sideEngineShared.distance_filter_meters = 20 //(Optional)
            
            //The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
            sideEngineShared.low_frequency_intervals_seconds = 15 //(Optional)
            
            //The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
            sideEngineShared.high_frequency_intervals_seconds = 3 //(Optional)
            
            //It is recommended to activate the high frequency mode when the SOS function is engaged in order to enhance the quality of the live tracking experience.
            sideEngineShared.high_frequency_mode_enabled = false //(Optional)
            
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
            if response.type == .configure && response.success == true {
                //You are now able to initiate the SIDE engine process at any time. In the event that there is no user input button available to commence the activity, you may commence the SIDE engine by executing the following command:
                
                //sideEngineShared.startSideEngine()
            }
            else if response.type == .start && response.success == true {
                //Update your UI here (e.g. update START button color or text here when SIDE engine started)
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
                //You can initiate your bespoke countdown page from this interface, which must have a minimum timer interval of 30 seconds.
                //Upon completion of your custom countdown, it is imperative to invoke the 'notify partner' method to record the event on the dashboard and dispatch notifications via webhook, Slack, email and SMS.
                //If it is necessary to dispatch an SMS or Email for personal emergency purposes, please do so.
                
                if let confidence = response.payload?["confidence"] {
                    print("SIDE engine confidence is: \(confidence)")
                    self.confidenceLabel.text = "SIDE confidence is: \(confidence)"
                }
                //You can open your custom count down controller here in the custom theme
                if self.sideEngineShared.applicationTheme == .custom {
                    DispatchQueue.main.async {
                        let state = UIApplication.shared.applicationState
                        if state != .active {
                            self.present(self.customUIController, animated: true)
                        }else {
                            self.navigationController?.pushViewController(self.customUIController, animated: false)
                        }
                    }
                }
                
            }
            else if response.type == .incidentAutoCancel {
                // Please disregard your customised countdown page in this instance and refrain from invoking any functions from external engines. The external engine will autonomously handle any necessary actions.
                self.customUIController.cancelAutoIncident()
            }
            else if response.type == .incidentAlertSent {
                //This message is intended solely to provide notification regarding the transmission status of alerts. It is unnecessary to invoke any SIDE engine functions in this context.
            }
            else if response.type == .sms {
                //This message is intended solely to provide notification regarding the transmission status of Email. It is unnecessary to invoke any SIDE engine functions in this context.
            }else if response.type == .email {
                //This message is intended solely to provide notification regarding the transmission status of Email. It is unnecessary to invoke any SIDE engine functions in this context.
            }else if response.type == .resumeSideEngine {
                //The lateral engine has been restarted, and we are currently monitoring the device's sensors and location in order to analyse another potential incident.
            }
            else if response.type == .location {
                //You will receive the user's location update status in this location. The payload contains a CLLocation object, which allows you to read any parameters if necessary.
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



extension CustomThemeViewController: CustomTimerDelegate {
    func didFinishTimer() {
        self.sendEmail()
        self.sendSMS()
    }
}
