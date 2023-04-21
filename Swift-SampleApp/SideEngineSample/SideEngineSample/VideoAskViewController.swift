//
//  VideoAskViewController.swift
//  SideEngineSample
//
//  Created by Phoenix Innovate on 30/11/22.
//

import UIKit
import BBSideEngine
import WebKit

protocol VideoAskDelegate {
    func didFinishSurvey()
}

class VideoAskViewController: UIViewController {
    var delegate: VideoAskDelegate?
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //If video survey enable in the your partner
        if let videoUrl = URL(string:BBSideEngineManager.shared.surveyVideoURL) {
            let myRequest = URLRequest(url: videoUrl)
            self.webview.load(myRequest)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeTapped() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to end this survey?",         preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "End", style: .default, handler: { _ in
            if self.delegate != nil {
                self.delegate?.didFinishSurvey()
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
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
