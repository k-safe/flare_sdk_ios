//
//  SimpleUIViewController.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 19/06/24.
//

import UIKit
import BBSideEngine

class SimpleUIViewController: UIViewController {
    @IBOutlet weak var productionButton: UIButton!
    @IBOutlet weak var sandboxButton: UIButton!
    @IBOutlet var startButton : UIButton!
    let sideEngineShared = BBSideEngineManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Initial sandbox mode is selected
        configureUI()
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
        
        //------------Configure Side Engine------------
        self.sideEngineConfigure(isProduction: true)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    func configureUI() {
        self.sandboxButton.setImage(UIImage(named: "checked"), for: .selected)
        self.sandboxButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        self.productionButton.setImage(UIImage(named: "checked"), for: .selected)
        self.productionButton.setImage(UIImage(named: "un_checked"), for: .normal)
        self.sandboxButton.isSelected = false
        self.productionButton.isSelected = true
        self.startButton.tag = 1
    }
    @IBAction func updateModeTapped(button: UIButton) {
        
        //Stop Side Engine if already started
        if self.startButton.tag == 2 {
            self.sideEngineShared.stopSideEngine()
        }
        
        if button.tag == 1 {
            self.sandboxButton.isSelected = true
            self.productionButton.isSelected = false
            self.sideEngineConfigure(isProduction: false)
        }else if button.tag == 2 {
            self.sandboxButton.isSelected = false
            self.productionButton.isSelected = true
            self.sideEngineConfigure(isProduction: true)
        }
    }

    //TODO: SIDE engine live mode
    @IBAction func startPressed(button : UIButton) {
        //Start and Stop SIDE engine
        if self.startButton.tag == 1 {
            self.selectActivity()
        } else {
            //stopSideEngine will stop all the services inside SIDE engine and release all the varibales
            self.sideEngineShared.stopSideEngine()
        }
        
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure(isProduction: Bool) {
        
        SwiftLoader.show(animated: true)
        
        let shared = BBSideEngineManager.shared
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
        let mode: BBMode = isProduction ? .production : .sandbox
        
        let accessKey = isProduction ? AppConfig.Keys.production_key : AppConfig.Keys.sandbox_key
        let secretKey = AppConfig.Keys.app_secret_key
        
        /*========================================================
         The default app will use user device's region, but you can also set a custom region based on your need.
         ========================================================*/
        shared.configure(accessKey: accessKey, secretKey: secretKey, mode: mode, theme: .custom)
        //shared.configure(accessKey: accessKey, secretKey: secretKey, mode: mode, theme: .custom, region: "region here")
        
        
    }
    
    
    //Select Activity type (optional) - Default activity type: Scooter
    func selectActivity() {
        let alert = UIAlertController(title: "", message: "Select Activity", preferredStyle: .actionSheet)
        let activity1 = "Bike"
        let activity2 = "Scooter"
//        let activity3 = "Cycling"
        alert.addAction(UIAlertAction(title: activity1, style: UIAlertAction.Style.default, handler: { _ in
            self.startSideEngine(activity: activity1)
        }))
        alert.addAction(UIAlertAction(title: activity2, style: UIAlertAction.Style.default, handler: { _ in
            self.startSideEngine(activity: activity2)
        }))
//        alert.addAction(UIAlertAction(title: activity3, style: UIAlertAction.Style.default, handler: { _ in
//            self.startSideEngine(activity: activity3)
//        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
            //Cancel Action
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
        
    }
    //TODO: Start SIDE Engine
    func startSideEngine(activity: String) {
        sideEngineShared.showLog = false //false when release app to the store
        
        sideEngineShared.activateIncidentTestMode = true //This is only used in sandbox mode and is TRUE by default. This is why you should test your workflow in sandbox mode. You can change it to FALSE if you want to experience real-life incident detection
        
        
        //Start SIDE engine
        sideEngineShared.startSideEngine(activity: activity)
    }
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        sideEngineShared.sideEventsListener { [weak self] (response) in
            guard let self = self else { return }
            if response.type == .configure {
                //You are now able to initiate the SIDE engine process at any time. In the event that there is no user input button available to commence the activity, you may commence the SIDE engine by executing the following command:
                if response.success == true {
                    //sideEngineShared.startSideEngine()
                }
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
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
            else if response.type == .incidentDetected && response.success == true {
                //You can initiate your bespoke countdown page from this interface, which must have a minimum timer interval of 30 seconds.
                //Upon completion of your custom countdown, it is imperative to invoke the 'notify partner' method to record the event on the dashboard and dispatch notifications via webhook, Slack, email and SMS.
                //If it is necessary to dispatch an SMS or Email for personal emergency purposes, please do so.
                
                if let confidence = response.payload?["confidence"] {
                    print("SIDE engine confidence is: \(confidence)")
                }
                //You can open your custom count down controller here in the custom theme
                if self.sideEngineShared.applicationTheme == .custom {
                   
                    DispatchQueue.main.async {
                        self.launchIncidentConfirmation()
                    }
                }
                
            }
            else if response.type == .incidentAutoCancel {
                // Please disregard your customised countdown page in this instance and refrain from invoking any functions from external engines. The external engine will autonomously handle any necessary actions.
//                if let controller = self.customUIController {
//                    controller.cancelAutoIncident()
//                }
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
                //Update your UI here (e.g. update PAUSE button color or text here when SIDE engine resume)
                
            }else if response.type == .pauseSideEngine {
                //The lateral engine has been restarted, and we are currently monitoring the device's sensors and location in order to analyse another potential incident.
            }
            else if response.type == .location {
                //You will receive the user's location update status in this location. The payload contains a CLLocation object, which allows you to read any parameters if necessary.
            }
        }
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


//Handle incident confirmation navigation
extension SimpleUIViewController: IncidentConfirmationDelegete {
    @objc public func launchIncidentConfirmation() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IncidentConfirmationViewController") as! IncidentConfirmationViewController
        controller.delegate = self
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .pageSheet
        
        if let sheet = navigation.sheetPresentationController {
            if #available(iOS 16.0, *) {
                // Define a custom detent with a specific height
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return 440 // Set your desired height here
                }
                
                // Set the custom detent
                sheet.detents = [customDetent]
                
                // Optional: Set the preferred corner radius if you want to customize it
                sheet.preferredCornerRadius = 20
                
                // Optional: Set the selected detent to be your custom detent
                sheet.selectedDetentIdentifier = customDetent.identifier
            } else {
                // Fallback for iOS versions earlier than 16.0
                sheet.detents = [.large()]
            }
        }
        print("Present bottomsheet")
        self.present(navigation, animated: true, completion: nil)
    }
    func confirmedIncident() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "IncidentResultViewController") as! IncidentResultViewController
        //This is used to send SMS or email to emergency contact
//        controller.countryCode = self.countryCode.text
//        controller.emergencyContact = self.phoneNumber.text
//        controller.emergencyContactName = self.riderName.text
//        controller.emergencyContactEmail = self.riderEmail.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
