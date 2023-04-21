//
//  ViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 12/07/2021.
//

import UIKit
import BBSideEngine

class ViewController: UIViewController {
    
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    @IBOutlet weak var modeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var sosButton: UIButton!
    
    @IBAction func changeMode(switchButton: UISwitch) {
        isProductionMode = switchButton.isOn
        if switchButton.isOn == false{
            self.sosButton.isHidden = true
        }else{
            self.sosButton.isHidden = false
        }
        self.modeLabel.text = isProductionMode ? "Production mode" : "Sandbox mode"
    }
    
    @IBAction func standardButtonTapped() {
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
        controller.isProductionMode = self.isProductionMode
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

