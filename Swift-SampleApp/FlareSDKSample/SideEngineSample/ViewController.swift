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
    
    @IBOutlet weak var productionButton: UIButton!
    @IBOutlet weak var sandboxButton: UIButton!
    @IBOutlet weak var sosButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    func configureUI() {
        self.sandboxButton.setImage(UIImage(named: "checked"), for: .selected)
        self.sandboxButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
        self.productionButton.setImage(UIImage(named: "checked"), for: .selected)
        self.productionButton.setImage(UIImage(named: "un_checked"), for: .normal)
        
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
    
    @IBAction func flareAwareTapped() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "FlareAwareViewController") as! FlareAwareViewController
        controller.isProductionMode = self.isProductionMode
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

