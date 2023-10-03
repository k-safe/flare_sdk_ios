//
//  FlareAwareViewController.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 01/05/23.
//

import UIKit
import BBSideEngine


class FlareAwareViewController: UIViewController {

    let sideEngineShared = BBSideEngineManager.shared
    @IBOutlet weak var startButton: UIButton!
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startButton.tag = 1
        
        //Configure SIDE engine and register listner
        self.sideEngineConfigure()
    }
    
    @IBAction func startPressed(button: UIButton) {
        
        if self.startButton.tag == 1 {
            //It is possible to activate the distance filter in order to transmit location data in the Flare aware network. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
            sideEngineShared.distance_filter_meters = 20
            
            //The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
            sideEngineShared.low_frequency_intervals_seconds = 15
            
            //The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
            sideEngineShared.high_frequency_intervals_seconds = 3
            
            //It is recommended to activate the high frequency mode when the startFlareAware() function is engaged in order to enhance the quality of the Fleet users experience.
            sideEngineShared.high_frequency_mode_enabled = true
            
            sideEngineShared.startFlareAware()
        }else {
            sideEngineShared.stopFlareAware()
        }
        
        
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure() {
        let shared = BBSideEngineManager.shared
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
        //let accessKey = "Your production license key here"
        let mode: BBMode = isProductionMode ? .production : .sandbox
        let accessKey = isProductionMode ? "8b53824f-ed7a-4829-860b-f6161c568fad" : "9518a8f7-a55f-41f4-9eaa-963bdb1fce5f" //Production
        shared.configure(accessKey: accessKey, mode: mode, theme: .standard)
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
    }
    
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        sideEngineShared.sideEventsListener { [weak self] (response) in
            guard let self = self else { return }
            //This call back basiclly where you call the configure method
            if response.type == .configure && response.success == true {
                //You are now able to initiate the SIDE engine process at any time. In the event that there is no user input button available to commence the activity, you may commence the SIDE engine by executing the following command:
                print("CONFIGURE with status: \(String(describing: response.success))")
            }
            else if response.type == .startFlareAware {
                //Update your UI here (e.g. update START button color or text here when SIDE engine started)
                print("START Flare Aware live mode with status: \(String(describing: response.success))")
                
                if response.success == true {
                    self.startButton.tag = 2
                    self.startButton.setTitle("STOP Flare Aware", for: .normal)
                    self.startButton.backgroundColor = .red
                } else {
                    //Handle error message here
                    print("Error message: \(String(describing: response.payload))")
                }
            }
            else if response.type == .stopFlareAware && response.success == true {
                //Update your UI here (e.g. update STOP button color or text here when SIDE engine stopped)
                print("STOP live mode with status: \(String(describing: response.success))")
                self.startButton.tag = 1
                self.startButton.setTitle("START Flare Aware", for: .normal)
                self.startButton.backgroundColor = .systemGreen
                
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
