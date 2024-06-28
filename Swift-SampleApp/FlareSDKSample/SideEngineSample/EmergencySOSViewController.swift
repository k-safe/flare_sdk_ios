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
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnActivate: UIButton!
    @IBOutlet weak var riderName: UITextField!
   
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
        
        //Show loading indicator while configuration in process
        SwiftLoader.show(animated: true)
        
        
        /****How to configure production mode****/
        //The live tracking feature is solely accessible in the production mode. Therefore, it is imperative that the side engine configuration method is set up in accordance with the production mode.
        //Flare producation
//        let accessKey = "Production key here"
//        let secretKey = "Secret key here"
        let accessKey = "Production key here"
        let secretKey = "Secret key"
        
        sideEngineShared.configure(accessKey: accessKey, secretKey: secretKey, mode: .production, theme: .standard)
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
        
    }
    @IBAction func btnSOSAction(_ sender: Any) {
        
        if self.btnActivate.tag == 1 {
            sideEngineShared.riderEmail = ""
            sideEngineShared.riderName = riderName.text! //Rider Name (optional)
            sideEngineShared.riderId = self.uniqueId() // Unique rider ID (optional)
            sideEngineShared.showLog = false //Default true //false when release app to the store
            
            //It is possible to activate the distance filter in order to transmit location data in the live tracking URL. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
            sideEngineShared.distance_filter_meters = 20
            
            //The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
            sideEngineShared.low_frequency_intervals_seconds = 15
            
            //The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
            sideEngineShared.high_frequency_intervals_seconds = 3
            
            //It is recommended to activate the high frequency mode when the SOS function is engaged in order to enhance the quality of the live tracking experience.
            sideEngineShared.high_frequency_mode_enabled = true 
            
            sideEngineShared.startSOS()
        }else {
            sideEngineShared.stopSOS()
        }
        
    }
    
    
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        sideEngineShared.sideEventsListener { [weak self] (response) in
            guard let self = self else { return }
            //This call back basiclly where you call the configure method
            if response.type == .configure {
                //You now have the capability to activate an SOS signal at any time. In the event that a user input button is unavailable, you may activate the SOS signal using the function provided below.:
                if response.success == true {
                    //sideEngineShared.activeSOS()
                }
                
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
            }
            else if response.type == .startSOS && response.success == true {
                //The SOS function has been activated. You may now proceed to update your user interface and share a live location tracking link with your social contacts, thereby enabling them to access your real-time location.
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
            }else if response.type == .stopSOS && response.success == true {
                //Disabling the SOS function will cease the transmission of location data to the live tracking dashboard and free up system memory resources, thereby conserving battery and data consumption.
                DispatchQueue.main.async {
                    self.btnActivate.tag = 1
                    self.btnShare.isHidden = true
                    self.btnActivate.setTitle("ACTIVATE SOS", for: .normal)
                    self.btnActivate.backgroundColor = .systemGreen
                }
            }else if response.type == .location {
                //You will receive the user's location update status in this location. The payload contains a CLLocation object, which allows you to read any parameters if necessary.
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
   
    //Generate random uniqueID
    func uniqueId() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    
}
