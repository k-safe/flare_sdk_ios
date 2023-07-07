//
//  EmergencySOSViewController.m
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import "EmergencySOSViewController.h"

@interface EmergencySOSViewController ()

@end

@implementation EmergencySOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnShare.hidden = YES;
    self.btnActivate.tag = 1;
    [self sideEngineConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)sideEngineConfigure {
    /****How to configure production mode****/
    // The live tracking feature is solely accessible in the production mode. Therefore, it is imperative that the side engine configuration method is set up in accordance with the production mode.
//    NSString *accessKey = @"Your production license key here";
    NSString *accessKey = @"8b53824f-ed7a-4829-860b-f6161c568fad" ;

    self.sideEngineShared = [BBSideEngineManager shared];
    [self.sideEngineShared configureWithAccessKey:accessKey mode:BBModeProduction theme:BBThemeStandard];

    //------------Register SIDE engine listener here------------
    [self registerSideEngineListener];
}

- (IBAction)btnSOSAction:(id)sender {
    if (self.btnActivate.tag == 1) {
        self.sideEngineShared.riderEmail = @"";
        self.sideEngineShared.riderName = self.riderName.text; // Rider Name (optional)
        self.sideEngineShared.riderId = [self uniqueId]; // Unique rider ID (optional)
        self.sideEngineShared.showLog = NO; // Default true // false when release app to the store

        // It is possible to activate the distance filter in order to transmit location data in the live tracking URL. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
        self.sideEngineShared.distance_filter_meters = 20;

        // The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "self.sideEngineShared.high_frequency_mode_enabled = false" is invoked.
        self.sideEngineShared.low_frequency_intervals_seconds = 15;

        // The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "self.sideEngineShared.high_frequency_mode_enabled = true" is invoked.
        self.sideEngineShared.high_frequency_intervals_seconds = 3;

        // It is recommended to activate the high frequency mode when the SOS function is engaged in order to enhance the quality of the live tracking experience.
        self.sideEngineShared.high_frequency_mode_enabled = YES;

        [self.sideEngineShared activeSOS];
    } else {
        [self.sideEngineShared deActiveSOS];
    }
}

- (void)registerSideEngineListener {
    __weak typeof(self) weakSelf = self;
    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse * response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // This call back basically where you call the configure method
        if (response.type == BBSideOperationConfigure && response.success) {
            // You now have the capability to activate an SOS signal at any time. In the event that a user input button is unavailable, you may activate the SOS signal using the function provided below.:
            // [strongSelf.sideEngineShared activeSOS];
        } else if (response.type == BBSideOperationSosActive && response.success) {
            // The SOS function has been activated. You may now proceed to update your user interface and share a live location tracking link with your social contacts, thereby enabling them to access your real-time location.
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.btnShare.hidden = NO;
                strongSelf.btnActivate.tag = 2;
                NSString *sosLiveTrackingUrl = response.payload[@"sosLiveTrackingUrl"];
                NSLog(@"Tracking URL: %@", sosLiveTrackingUrl);
                strongSelf.shareLink = sosLiveTrackingUrl;
                [strongSelf.btnActivate setTitle:@"DEACTIVATE SOS" forState:UIControlStateNormal];
                strongSelf.btnActivate.backgroundColor = [UIColor systemRedColor];
            });
        } else if (response.type == BBSideOperationSosDeActive && response.success) {
            // Disabling the SOS function will cease the transmission of location data to the live tracking dashboard and free up system memory resources, thereby conserving battery and data consumption.
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.btnActivate.tag = 1;
                strongSelf.btnShare.hidden = YES;
                [strongSelf.btnActivate setTitle:@"ACTIVATE SOS" forState:UIControlStateNormal];
                strongSelf.btnActivate.backgroundColor = [UIColor systemGreenColor];
            });
        } else if (response.type == BBSideOperationLocation) {
            // You will receive the user's location update status in this location. The payload contains a CLLocation object, which allows you to read any parameters if necessary.
        }
    }];
    
 }

- (IBAction)btnShare:(id)sender {
    NSURL *url = [NSURL URLWithString:self.shareLink];
    NSString *text = @"SOS Live track link";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    if ([activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = self.view.bounds;
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (NSString *)uniqueId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
