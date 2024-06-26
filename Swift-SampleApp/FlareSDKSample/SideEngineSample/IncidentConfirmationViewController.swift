//
//  IncidentConfirmationViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 20/04/2022.
//

import UIKit
import AVFoundation
import AudioToolbox
import BBSideEngine

protocol IncidentConfirmationDelegete {
    func confirmedIncident()
}

class IncidentConfirmationViewController: UIViewController {
    var delegate: IncidentConfirmationDelegete?
    
    @IBOutlet var countDownLabel : UILabel!
    
    //Handle countdown timer
    var counter = BBSideEngineManager.shared.countDownDuration
    var counterTimer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureTimer()
     }
    @IBAction func reportAnIncident() {
        BBSideEngineManager.shared.confirmIncident()
        self.stopTimer(finished: true)
    }
    @IBAction func userTappedOk() {
        BBSideEngineManager.shared.declineIncident()
        self.stopTimer(finished: false)
        self.dismissIncident()
    }
    
    
    func dismissIncident() {
        BBSideEngineManager.shared.resumeSideEngine() //You need to resume side engine when go to back screen
        self.dismiss(animated: true)
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
 
}


//--------------------------------------------------------//
//MARK: **************UI**************
//--------------------------------------------------------//
extension IncidentConfirmationViewController {
    //TODO: Configure Timer
    func configureTimer () {
         countDownLabel.text = "\(counter)"
         self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimer), userInfo: nil, repeats: true)
      }
    
    
    //TODO: Support screen
    func openSupportScreen() {
        if self.delegate != nil {
            self.delegate?.confirmedIncident()
            self.dismiss(animated: true)
        }
    }
 
}

//--------------------------------------------------------//
//MARK: **************Start count down timer**************
//--------------------------------------------------------//
extension IncidentConfirmationViewController{
    @objc func runTimer() {
        counter = counter - 1
        countDownLabel.text = "\(counter)"
        if counter >= 0 {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if (counter <= 0) {
            self.stopTimer(finished: false)
            self.dismissIncident()
        }
    }
    
    func stopTimer(finished : Bool) {
        countDownLabel.text = "\(0)"
        self.counter = 0
        if self.counterTimer != nil{
            self.counterTimer.invalidate()
            self.counterTimer = nil
         }
        
        if finished == true {
            self.openSupportScreen()
        }
     }
}


