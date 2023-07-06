//
//  TestSideEngineSupportViewController.swift
//  SideEngineSample
//
//  Created by Phoenix on 20/04/2022.
//

import UIKit
import MapKit
import BBSideEngine
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class TestSideEngineSupportViewController: UIViewController, VideoAskDelegate {
    @IBOutlet var mapview : MKMapView!
    @IBOutlet var latitudeLabel : UILabel!
    @IBOutlet var longitudeLabel : UILabel!
    @IBOutlet weak var w3wLink: UILabel!

    var mapUrl = ""
    var lat :Double = 0.0
    var lng :Double = 0.0
    
    let payload = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view   .
        self.mapview.delegate = self
 
        //Fetch location from what3word
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMap(_:)))
        w3wLink.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    //TODO: fetch location from what3word
    func fetchLocation() {
        
        BBSideEngineManager.shared.fetchWhat3WordLocation { [weak self] response in
            
            if let tempRes = response["response"] as? NSDictionary {
                guard let self = self else { return }
                if let coordinates = tempRes.object(forKey: "coordinates") as? NSDictionary {
                    if let tempLat = coordinates.object(forKey: "lat") as? NSNumber {
                        self.lat = tempLat.doubleValue
                    }
                    if let tempLng = coordinates.object(forKey: "lng") as? NSNumber {
                        self.lng = tempLng.doubleValue
                    }
                    
                }
                var nearestPlace = ""
                if let place = tempRes.object(forKey: "nearestPlace") as? String {
                    nearestPlace = place
                }
                if let map = tempRes.object(forKey: "map") as? String {
                    self.mapUrl = map
                }
                if let words = tempRes.object(forKey: "words") as? String {
                    DispatchQueue.main.async {
                    self.w3wLink.text = "//\(words)"
                    }
                }
                
                DispatchQueue.main.async {
                    self.setRegion(lat: self.lat, lng: self.lng, nearestPlace: nearestPlace)
                }
                
            }
        }
        
        
    }
    
    func setRegion(lat : Double, lng : Double, nearestPlace: String) {
        
        self.payload.setValue(["latitude": lat, "longitude": lng], forKey: "location")
        
        self.latitudeLabel.text = "Latitude: \(lat)"
        self.longitudeLabel.text = "Longitude: \(lng)"
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        self.mapview.setRegion(region, animated: true)
        
        let london = MKPointAnnotation()
        london.title = nearestPlace
        london.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.mapview.addAnnotation(london)
        
    }
    
    @objc func tappedMap(_ sender: UITapGestureRecognizer? = nil) {
        if self.mapUrl.isEmpty == false {
            if let url = URL(string: self.mapUrl) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func closeTapped() {
        
        if BBSideEngineManager.shared.surveyVideoURL.isEmpty == false {
            
            //Use desined UI to open video sruvey
//            BBSideEngineManager.shared.presentVideoSurveys()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let videoAskViewController = storyBoard.instantiateViewController(withIdentifier: "VideoAskViewController") as! VideoAskViewController
            videoAskViewController.delegate = self
            DispatchQueue.main.async {
                self.present(videoAskViewController, animated: true)
            }
            
        }else {
            DispatchQueue.main.async {
                self.didFinishSurvey()
            }
        }
        
    }
    
    func didFinishSurvey() {
        BBSideEngineManager.shared.resumeSideEngine() //You need to resume side engine when go to back screen
        var isNavigate: Bool = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CustomThemeViewController.self) {
                isNavigate = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if isNavigate == false {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
 
}
 


extension TestSideEngineSupportViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        
        if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
             let imgAnotaion = UIImage(named: "mappin",
                                in: Bundle(for: type(of:self)),
                                compatibleWith: nil)
                annotationView?.image = imgAnotaion
            } else {
                annotationView?.annotation = annotation
            }
        return annotationView
    }
}
 
