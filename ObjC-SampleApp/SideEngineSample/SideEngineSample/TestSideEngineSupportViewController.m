//
//  TestSideEngineSupportViewController.m
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import "TestSideEngineSupportViewController.h"

@interface TestSideEngineSupportViewController ()

@end

@implementation TestSideEngineSupportViewController
@synthesize mapview,latitudeLabel,longitudeLabel,w3wLink,mapUrl,lat,lng,payload;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapview setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMap:)];
    [w3wLink addGestureRecognizer:tap];
    //Fetch location from what3word
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchLocation];
}
- (IBAction)closeTapped:(UIButton *)sender {
    [[BBSideEngineManager shared] resumeSideEngine];
    bool isNavigate = NO;
    for (UIViewController *controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[CustomThemeViewController class]]) {
            isNavigate = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (isNavigate == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//TODO: fetch location from what3word
-(void)fetchLocation {
    [[BBSideEngineManager shared] fetchWhat3WordLocationWithCompletion:^(NSDictionary<NSString *,id> * response) {
        NSDictionary *tempRes = [response objectForKey:@"response"];
        if (tempRes != nil) {
            NSDictionary *coordinates = [tempRes objectForKey:@"coordinates"];
            if (coordinates != nil) {
                self.lat = [[coordinates objectForKey:@"lat"] doubleValue];
                self.lng = [[coordinates objectForKey:@"lng"] doubleValue];
            }
            
            NSString *nearestPlace = @"";
            nearestPlace = [tempRes objectForKey:@"nearestPlace"];
            self.mapUrl = [tempRes objectForKey:@"map"];
            
            NSString *words = [tempRes objectForKey:@"words"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.w3wLink setText:[NSString stringWithFormat:@"//%@",words]];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setRegionlat:self.lat lng:self.lng nearPlace:nearestPlace];
            });
        }
    }];
}


-(void)setRegionlat:(double)lat lng:(double)lng nearPlace:(NSString *)nearestPlace {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",lat],@"latitude",[NSString stringWithFormat:@"%f",lng],@"longitude", nil];
    [[self payload] setValue:dict forKey:@"location"];
    [self.latitudeLabel setText:[NSString stringWithFormat:@"Latitude: %f",lat]];
    [self.longitudeLabel setText:[NSString stringWithFormat:@"Longitude: %f",lng]];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat, lng);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.009, 0.009));
    [self.mapview setRegion:region animated:YES];
    
    MKPointAnnotation *london = [[MKPointAnnotation alloc] init];
    [london setTitle:nearestPlace];
    [london setCoordinate:CLLocationCoordinate2DMake(lat, lng)];
    [self.mapview addAnnotation:london];
}

-(void)tappedMap:(UITapGestureRecognizer *)sender {
    if ([self.mapUrl isEqualToString:@""] == NO) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:self.mapUrl];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:URL options:@{}
               completionHandler:^(BOOL success) {
                NSLog(@"Open %@: %d",self.mapUrl,success);
            }];
        } 
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"Annotation";
    MKAnnotationView *annotationView = [mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        [annotationView setCanShowCallout:YES];
        UIImage *imgAnotation = [UIImage imageNamed:@"mappin" inBundle:[NSBundle bundleForClass:[self class]] withConfiguration:nil];
        [annotationView setImage:imgAnotation];
    }
    else {
        [annotationView setAnnotation:annotation];
    }
    return  annotationView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
