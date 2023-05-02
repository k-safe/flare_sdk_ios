//
//  TestViewModeController.swift
//  SideEngineSample
//
//  Created by Phoenix on 4/4/22.
//

import UIKit
import BBSideEngine
class TestViewModeController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func backToHome() {
        BBSideEngineManager.shared.resumeSideEngine() //You need to resume side engine when go to back screen
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    @IBAction func closeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
