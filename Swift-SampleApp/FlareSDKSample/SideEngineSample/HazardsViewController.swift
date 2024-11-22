//
//  FlareAwareViewController.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 01/05/23.
//

import UIKit
import BBSideEngine
import MapKit

class HazardsViewController: UIViewController {
    
    let shared = BBSideEngineManager.shared
    
    var isProductionMode: Bool = true //This will used to configure SDK production or sandbox mode
    var selectedRegion: String = ""
    @IBOutlet var mapview : MKMapView!
    var isHazardFeatureEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        //Configure Flare SDK and register listner
        
        self.setHazardSettings() //Set hazards settings, ignore this if you do not want to disable hazard for specific user
        
        //Start Flare SDK configuration
        self.sideEngineConfigure()
    }
    
    //TODO: Enable or Disable Hazard
    func setHazardSettings() {
        BBSideEngineManager.shared.isHazardFeatureEnabled = isHazardFeatureEnabled //Default true for everyone
    }
    
    //TODO: Configure SIDE engine and register listner
    func sideEngineConfigure() {
        //Show loading indicator while configuration in process
        SwiftLoader.show(animated: true)
        
        let shared = BBSideEngineManager.shared
        /****How to configure production mode****/
        //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
        //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
        
        /*
         ==================================================
         Find the Flare SDK access key and secret key from the partner portal using the URL given below.
         https://partner.flaresafety.com/sdk
         ==================================================
         */
        let mode: BBMode = .production
        let accessKey = AppConfig.Keys.production_key
        let secretKey = AppConfig.Keys.app_secret_key
        
        shared.configure(accessKey: accessKey, secretKey: secretKey, mode: mode, theme: .standard, region: selectedRegion)
        
        //------------Register SIDE engine listener here------------
        self.registerSideEngineListener()
    }
    
    //TODO: Register SIDE engine listener to receive call back from side engine
    func registerSideEngineListener() {
        shared.sideEventsListener { [weak self](response) in
            
            //This call back basiclly where you call the configure method
            if response.type == .configure {
                //Flare SDK is now successfully set up, so you can call fetch hazards to display them on your map, use report hazard to add a new hazard at a specific location, or use the manage hazard method to access the full hazards feature. See the example below on how to call a specific method to use the feature.
                
                print("CONFIGURE with status: \(String(describing: response.success))")
                if response.success == true {
                    //You can use the user action button to perform any of the actions listed here
                    //BBSideEngineManager.shared.reportHazard()
                    //BBSideEngineManager.shared.manageHazards()
                }
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
            }else if response.type == .fetchHazards {
                //Flare SDK automatically sends hazards once it has been successfully configured. It also automatically sends hazards when a user is moving and new hazards are detected in the user's area.
                if let payload = response.payload {
                    if response.success == true {
                        guard let self = self else { return }
                        self.refreshHazardsMap(response: payload)
                    }
                }
            }else if response.type == .reportHazard {
                //When users report hazards, you will receive an event to inform you about the reported hazards. You can either keep track of this on your side or send the event to your analytics for further use.
                if let payload = response.payload {
                    if response.success == false {
                        guard let self = self else { return }
                        if let message = payload["message"] as? String {
                            self.displayMessage(title: "Hazard", body: message)
                        }
                    } else {
                        print("Response: ", payload)
                    }
                    
                }
                
            }else if response.type == .manageHazard {
                //When the user opens the manage hazards page, you will receive an event here.
                //let hazards = BBSideEngineManager.shared.fetchHazards()
                
                if let payload = response.payload {
                    if response.success == false {
                        guard let self = self else { return }
                        if let message = payload["message"] as? String {
                            self.displayMessage(title: "Hazard", body: message)
                        }
                    } else {
                        print("Response: ", payload)
                    }
                    
                }
            }else if response.type == .updateLocation {
                //You will receive the didUpdateLocations callback from Apple here to get the user's current position or to update your maps to keep them centred.
                if response.success == true {
                    if let payload = response.payload {
                        if let location = payload["location"] as? CLLocation {
                            guard let self = self else { return }
                            self.recenterMap(location: location)
                        }
                    }
                }
                
            }
            else if response.type == .deleteHazard {
                //When the user delete hazards, you will receive an event here.
                if let payload = response.payload {
                    print("Response: ", payload)
                }
            }else if response.type == .alertedHazard {
                //When users are driving within a 50 meters radius of hazards, the Flare SDK will send them a local notification about the hazards. You will receive an event here when the user is notified.
                if let payload = response.payload {
                    print("Response: ", payload)
                }
            }else if response.type == .feedbackHazard {
                //When the user taps on the hazard alerts, they will be asked for feedback on whether the hazard is still present. User have to submit their feedback by choosing either "Yes" or "No." Once the user submits their feedback, you will receive an event here.
                if let payload = response.payload {
                    print("Response: ", payload)
                }
            }
            
        }
    }
    
    //TODO: Hazards module actions
    @IBAction func reportHazardTapped() {
        BBSideEngineManager.shared.reportHazard()
    }
    @IBAction func manageHazardTapped() {
        BBSideEngineManager.shared.manageHazards()
    }
    @IBAction func fetchHazardsTapped() {
        let hazards = shared.fetchHazards()
        print("Flare SDK Hazards: ", hazards)
    }
    /* Recenter Maps when user has moving */
    func recenterMap(location: CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
        self.mapview.setRegion(region, animated: true)
    }
    /* Refresh Maps */
    func refreshHazardsMap(response: [String: Any]) {
        //Fetched hazards in radius(meters)
        //guard let proximityRadiusInMeters = response["proximityRadiusInMeters"] as? Double else { return }
        
        DispatchQueue.main.async {
            self.mapview.removeAnnotations(self.mapview.annotations)
        }
        
        guard let latitude = response["currentLat"] as? Double else { return }
        guard let longitude = response["currentLon"] as? Double else { return }
        
        //Center maps on current location where hazards fetched
        DispatchQueue.main.async {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
            self.mapview.setRegion(region, animated: true)
        }
        
        guard let hazards = response["hazards"] as? [[String: Any]] else { return }
        
        for hazard in hazards {
            
            guard let lat = hazard["lat"] as? Double, let lon = hazard["lon"] as? Double, let name = hazard["name"] as? String else
            { continue }
            
            var annotationImage: UIImage?
            if let image = hazard["image"] as? UIImage {
                annotationImage = image
            }
            let annotation = HazardAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                title: name,
                image: annotationImage
            )
            
            DispatchQueue.main.async {
                self.mapview.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func displayMessage(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

        }))
        self.present(alert, animated: true)
        
    }
   
    
}

extension HazardsViewController: MKMapViewDelegate {
    // Delegate method to provide custom annotation view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        // Set custom image based on the annotation's imageName
        if let hazardAnnotation = annotation as? HazardAnnotation, let image = hazardAnnotation.image {
            
            annotationView?.setImage(image)
            
            // Optionally, adjust the frame size
            annotationView?.frame.size = CGSize(width: 60, height: 60)  // Adjust as needed
        }
        
        return annotationView
    }

    
}
