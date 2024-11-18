//
//  ViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine
import Foundation
import SwiftUI

class ViewController: UIViewController {
    var isProductionMode: Bool = false //This will used to configure SDK production or sandbox mode
    @IBOutlet weak var productionButton: UIButton!
    @IBOutlet weak var sandboxButton: UIButton!
    @IBOutlet weak var regionContainerView: UIView!
    @IBOutlet weak var enabledHazardSwitch: UISwitch!
    
    // Create an instance of the RegionSelection observable object
    private var regionSelection = RegionSelection()
    
    
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
        self.configureRegionUI()
    }
    
    //Create Region UI
    func configureRegionUI() {
        let regions: [String] = ["GB", "IN", "HK"]
        
        // Create an instance of your SwiftUI view
        let regionDropDown = RegionDropDown(regionSelection: regionSelection, regions: regions)
        // Create an instance of your SwiftUI view
        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: regionDropDown)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        
        // Add the SwiftUI view to the container view
        regionContainerView.addSubview(hostingController.view)
        
        // Set up constraints to match the container view's size
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: regionContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: regionContainerView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: regionContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: regionContainerView.bottomAnchor)
        ])
        
        // Notify the hosting controller that it has moved to a parent view controller
        hostingController.didMove(toParent: self)
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
        controller.selectedRegion = regionSelection.selectedRegion
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func customButtonTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "CustomThemeViewController") as! CustomThemeViewController
        controller.isProductionMode = self.isProductionMode
        controller.selectedRegion = regionSelection.selectedRegion
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func sosButtonTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "EmergencySOSViewController") as! EmergencySOSViewController
        controller.selectedRegion = regionSelection.selectedRegion
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func flareAwareTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "FlareAwareViewController") as! FlareAwareViewController
        controller.isProductionMode = self.isProductionMode
        controller.selectedRegion = regionSelection.selectedRegion
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func hazardButtonTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "HazardsViewController") as! HazardsViewController
        controller.selectedRegion = regionSelection.selectedRegion
        controller.isHazardFeatureEnabled = enabledHazardSwitch.isOn
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
