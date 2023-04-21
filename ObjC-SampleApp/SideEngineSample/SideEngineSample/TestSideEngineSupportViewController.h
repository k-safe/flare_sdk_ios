//
//  TestSideEngineSupportViewController.h
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import <UIKit/UIKit.h>
#import "CustomThemeViewController.h"

@import MapKit;
@import BBSideEngine;

NS_ASSUME_NONNULL_BEGIN

@interface TestSideEngineSupportViewController : UIViewController<MKMapViewDelegate>
{
    
}

@property(nonatomic, weak) IBOutlet MKMapView *mapview;
@property(nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property(nonatomic, weak) IBOutlet UILabel *longitudeLabel;
@property(nonatomic, weak) IBOutlet UILabel *w3wLink;

@property(nonatomic, strong) NSString *mapUrl;
@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lng;
@property(nonatomic, strong) NSMutableDictionary *payload;

/**
 var mapUrl = ""
 var lat :Double = 0.0
 var lng :Double = 0.0
 
 let payload = NSMutableDictionary()
 */
- (IBAction)closeTapped:(UIButton *)sender;
@end
/**
 @IBOutlet var mapview : MKMapView!
 @IBOutlet var latitudeLabel : UILabel!
 @IBOutlet var longitudeLabel : UILabel!
 @IBOutlet weak var w3wLink: UILabel!
 */
NS_ASSUME_NONNULL_END
