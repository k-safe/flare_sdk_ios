//
//  ViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine
import Foundation

class ViewController: UIViewController {
    var isProductionMode: Bool = false //This will used to configure SDK production or sandbox mode
    @IBOutlet weak var productionButton: UIButton!
    @IBOutlet weak var sandboxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
    }
    func configureUI() {
        self.sandboxButton.setImage(UIImage(named: "checked"), for: .selected)
        self.sandboxButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        self.productionButton.setImage(UIImage(named: "checked"), for: .selected)
        self.productionButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        self.initConfigure()
    }
    func initConfigure() {
        self.isProductionMode = false
        self.sandboxButton.isSelected = true
        self.productionButton.isSelected = false
    }
    @IBAction func updateModeTapped(button: UIButton) {
        if button.tag == 1 {
            self.sandboxButton.isSelected = true
            self.productionButton.isSelected = false
            self.isProductionMode = false
        }else if button.tag == 2 {
            self.sandboxButton.isSelected = false
            self.productionButton.isSelected = true
            self.isProductionMode = true
        }
    }
    func testSheet() {
        
        let controller = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "IncidentConfirmationViewController") as! IncidentConfirmationViewController
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        
        navigation.modalPresentationStyle = .pageSheet
        if let sheet = navigation.sheetPresentationController {
            sheet.detents = [.large()]
        }
        self.present(navigation, animated: true, completion: nil)
        
    }
    

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
        
        self.present(navigation, animated: true, completion: nil)
    }

    func proceedConfirmIncident(title: String, body: String, incidentId: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            self.fetchIncidentById(incidentId: incidentId, action: kImOkButton)
        }))
        alert.addAction(UIAlertAction(title: "Not OK", style: .default, handler: { _ in
//            self.fetchIncidentById(incidentId: incidentId, action: kImNotOkButton)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func standardButtonTapped() {
        
        // Usage example
//        BBSideEngineManager.shared.launchIncidentClassification(controller: self) { incidentType in
//            print("Incident classification submitted with type: \(incidentType)")
//        } onClose: {
//            print("Incident classification closed")
//        }

       
//        self.launchIncidentConfirmation()
//        self.proceedConfirmIncident(title: "Tst", body: "hbshdjsd", incidentId: "sdsd")

//        return
//        BBSideEngineManager.shared.performAudioRecordingTasks()
//        return
        
        
//        fatalError("Crash was triggered")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "StandardThemeViewController") as! StandardThemeViewController
        controller.isProductionMode = self.isProductionMode
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func customButtonTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "CustomThemeViewController") as! CustomThemeViewController
        controller.isProductionMode = self.isProductionMode
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func sosButtonTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "EmergencySOSViewController") as! EmergencySOSViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func flareAwareTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "FlareAwareViewController") as! FlareAwareViewController
        controller.isProductionMode = self.isProductionMode
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}



extension ViewController: IncidentConfirmationDelegete {
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
