//
//  TestSideEngineViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 20/04/2022.
//

import UIKit
import AVFoundation
import AudioToolbox
import BBSideEngine

protocol CustomTimerDelegate {
    func didFinishTimer()
}
class CustomCountDownViewController: UIViewController {
  
    var delegate: CustomTimerDelegate?
    
    @IBOutlet var mainTitleLabel : UILabel!
    @IBOutlet var secondsLabel : UILabel!
    @IBOutlet var countDownLabel : UILabel!
    
    //Handle countdown timer
    var counter = BBSideEngineManager.shared.countDownDuration
    var counterTimer : Timer!
 
    var countryCode: String?
    var emergencyContact: String?
    var emergencyContactName: String?
    var emergencyContactEmail: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureTimer()
     }
    
    @IBAction func closeTapped() {
        self.stopTimer(finished: false)
        BBSideEngineManager.shared.resumeSideEngine() //You need to resume side engine when go to back screen
        if isModal == true {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func cancelAutoIncident()  {
        if self.counterTimer != nil{
            self.counterTimer.invalidate()
            self.counterTimer = nil
         }
        
        if isModal == true {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
 
}


//--------------------------------------------------------//
//MARK: **************UI**************
//--------------------------------------------------------//
extension CustomCountDownViewController {
    //TODO: Configure Timer
    func configureTimer () {
         countDownLabel.text = "\(counter)"
         self.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimer), userInfo: nil, repeats: true)
      }
    
    
    //TODO: Support screen
    func openSupportScreen() {
        
        let state = UIApplication.shared.applicationState
        if state != .active || isModal == true {
            
            //If App in the background mode then auto verify incident
            BBSideEngineManager.shared.notifyPartner()
            //Delegate used to send sms or email in user emergency contacts
            if self.delegate != nil {
                self.delegate?.didFinishTimer()
            }
            self.closeTapped() //Auto dismiss and resume side engine
        } else {
            DispatchQueue.main.async {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "TestSideEngineSupportViewController") as! TestSideEngineSupportViewController
                controller.countryCode = self.countryCode
                controller.emergencyContact = self.emergencyContact
                controller.emergencyContactName = self.emergencyContactName
                controller.emergencyContactEmail = self.emergencyContactEmail
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
    }
 
}

//--------------------------------------------------------//
//MARK: **************Start count down timer**************
//--------------------------------------------------------//
extension CustomCountDownViewController{
    @objc func runTimer() {
        counter = counter - 1
        countDownLabel.text = "\(counter)"
        if counter >= 0 {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if (counter <= 0) {
            self.stopTimer(finished: true)
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
            DispatchQueue.main.async {
                self.openSupportScreen()
            }
        }
     }
}


extension UIViewController {

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
