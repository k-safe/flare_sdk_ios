//
//  ViewController.swift
//  LimeSampleApp
//
//  Created by K-Safe on 01/06/23.
//

import UIKit
import BBSideEngine
import CoreLocation

class LimeSampleViewController: UIViewController {
    private var locationManager = CLLocationManager()
    private let shared = BBSideEngineManager.shared
    private var engineMode: BBMode = .production
    private var hasConfigured: Bool = false
    private var pendingBottomSheetTask: DispatchWorkItem?
    @IBOutlet private var startButton: UIButton!
    private var isJourneyStarted: Bool = false
    @IBOutlet private var messageLabel: UILabel!
    var counter: Int = 0
    
    @IBOutlet weak var productionButton: UIButton!
    @IBOutlet weak var sandboxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the user interface.
        self.configureUI()
        
        //Register listener for SIDE Engine
        self.configureSIDEEngineListener()
        
        
        self.displayMessage(message: "Please hold on while we set up the SIDE Engine in sandbox mode.")
        //Default mode is Sandbox
        self.configureSideEngine(licenseKey: "8b53824f-ed7a-4829-860b-f6161c568fad")
        
        self.configureLocation()
    }
    
    func configureLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    //Sandbox or Production mode can be changed from the UI
    func configureUI() {
        self.sandboxButton.setImage(UIImage(named: "checked"), for: .selected)
        self.sandboxButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        self.productionButton.setImage(UIImage(named: "checked"), for: .selected)
        self.productionButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        //Default mode is Sandbox
        self.sandboxButton.isSelected = false
        self.productionButton.isSelected = true
    }
    
    
    //SIDE Engine mode selected in UI
    @IBAction func changeModeTapped(button: UIButton) {
        if button.tag == 1 {
            
            //STOP your ride before switching between Sandbox and Production.
            if self.isJourneyStarted == true {
                self.shared.stopSideEngine()
            }
            
            self.hasConfigured = false //Reset configure flag
            self.sandboxButton.isSelected = true
            self.productionButton.isSelected = false
            self.engineMode = .sandbox
            self.displayMessage(message: "Please hold on while we switch to sandbox mode.")
            self.configureSideEngine(licenseKey: "Your sandbox license key here")
        }else if button.tag == 2 {
            self.hasConfigured = false //Reset configure flag
            
            //STOP your ride before switching between Sandbox and Production.
            if self.isJourneyStarted == true {
                self.shared.stopSideEngine()
            }
            
            self.hasConfigured = false
            self.sandboxButton.isSelected = false
            self.productionButton.isSelected = true
            self.engineMode = .production
            self.displayMessage(message: "Please hold on while we switch to production mode.")
            self.configureSideEngine(licenseKey: "Your production license key here")
        }
    }
    //SIDE Engine STOP/START is managed below.
    @IBAction func startPressed(button: UIButton) {
        if self.hasConfigured == true {
            if self.isJourneyStarted == false {
                shared.riderName = "Lime iOS"
                shared.showLog = false
                self.shared.startSideEngine()
            }else {
                self.shared.stopSideEngine()
            }
        }else {
            self.displayMessage(message: "Something went wrong while configuring SIDE Engine.")
        }
        
    }
    
    func startTracking() {
        shared.riderName = "Lime iOS"
        shared.showLog = false
        shared.enableActivityTelemetry = false
        self.shared.startSideEngine()
    }
    //Configuring and initialising SIDE Engine
    func configureSideEngine(licenseKey: String) {
        shared.configure(accessKey: licenseKey, mode: engineMode, theme: .custom)
    }
    
    //SIDE Engine listener needs to be registered ONLY once.
    func configureSIDEEngineListener() {
        //startSideEngine() has been moved inside the startPressed() function above.
//        shared.riderName = "Lime iOS"
//        shared.showLog = false
        shared.sideEventsListener { [weak self] response in
            guard let self = self else { return }
            switch response.type {
            case .configure:
                guard response.success else { return }
                
                self.hasConfigured = true
                //startSideEngine() has been moved inside the startPressed() function above.
                self.startTracking()
                
                //resumeSideEngine()<-- This should not be invoked here, as it remains unused, startSideEngine() function handles the rest of the process.
                //self.shared.resumeSideEngine()
                self.displayMessage(message: "Flare SIDE Engine configured, You can begin your journey at any time now.")
//                let crashArray = NSArray()
//                print("Crash array reporetd here:", crashArray.object(at: 1))
            case .incidentDetected:
                //stopSideEngine()<-- This should not be invoked here. The SDK handles all incident analysis and alerting internally. This function should only be called at the end of a journey i.e. a user ending a ride.
                //self.shared.stopSideEngine()
                
                //Code below looks fine
                self.showBottomSheetAfterDelay()
                self.displayMessage(message: "Flare incident detected, We've started a countdown of 30 seconds. Please wait for the next event.")
                
            case .incidentAutoCancel:
                //resumeSideEngine()<-- This should not be called at this point. The SIDE Engine will handle this process.
                //self.shared.resumeSideEngine()
                
                //Code below looks fine
                self.pendingBottomSheetTask?.cancel()
                self.displayMessage(message: "Flare incident auto cancelled:\(String(describing: response.payload))")
            case .location:
                print("Location:", self.fetchCurrentLocation()!)
                self.counter = self.counter + 1
                if self.counter >= 20 {
                    self.counter = 0
//                    self.pendingBottomSheetTask = nil
                    
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: self.pendingBottomSheetTask! )
//                self.showBottomSheetAfterDelay()
            case .start:
                self.isJourneyStarted = true
                self.startButton.setTitle("Stop", for: .normal)
                self.startButton.backgroundColor = .red
                self.displayMessage(message: "Flare SIDE Engine started")
            case .stop:
                self.isJourneyStarted = false
                self.startButton.setTitle("Start", for: .normal)
                self.startButton.backgroundColor = .systemGreen
                self.displayMessage(message: "Flare SIDE Engine stopped")
            default:
                break
            }
        }
        
        
        //configureSideEngine() function has been moved into viewDidLoad() & changeModeTapped() functions
        /*
        if !hasConfigured {
            configureSideEngine()
            This should be set to TRUE once you receive a successful response from the configure method on line number 47 mentioned above.
            hasConfigured = true
        }
         */
    }
    
    func resumeTracking() {
        
        //In the custom theme, you must make sure to use the resumeSideEngine() function after you've used the notifyPartner() method like shown below.
        shared.resumeSideEngine()
        
        //The stopSideEngine() function should only be used when the user has finished their journey. This function will end the entire SIDE Engine process.
        //shared.stopSideEngine()
        
        // cancel any pending requests
        pendingBottomSheetTask?.cancel()
        self.displayMessage(message: "Flare SIDE Engine will notify partner (SMS/WebHook/Email) and resume SIDE Engine")
    }
    
    
    @objc
    private func launchBottomsheet() {
        //Code below looks fine
//        self.shared.notifyPartner()
        
        //Changed the name of stopTracking() function to resumeTracking().
//        resumeTracking()
        
        let alert = UIAlertController(title: "Confirm", message: "Please confirm this is an real incident?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
//                fatalError()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button")
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        
    }
    
    /// shows a bottomsheet after an expected delay to wait for auto cancel
    private func showBottomSheetAfterDelay() {
        self.pendingBottomSheetTask?.cancel()
        let showBottomSheetTask = DispatchWorkItem {
//            let crashArray = NSArray()
//            print("Crash app because of invalid index:", crashArray.object(at: 1))
            self.launchBottomsheet()
        }
        self.pendingBottomSheetTask = showBottomSheetTask
        //Recommended countdown timer inteval is 30 seconds
//        self.pendingBottomSheetTask = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: showBottomSheetTask)
        
    }
    
    func displayMessage(message: String) {
        self.messageLabel.text = message
    }
    
    func fetchCurrentLocation() -> CLLocation? {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = self.locationManager.location else {
                return nil
            }
            return currentLocation
        }
        return nil
    }
}


extension LimeSampleViewController: CLLocationManagerDelegate {
    
    func  locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            print("Location something went wrong while fetching your location")
            return
        }
        print("Location is...",lastLocation)
        fatalError("Something wromg in the location")
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
