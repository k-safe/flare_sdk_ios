//
//  FlareAwareViewController.m
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import "FlareAwareViewController.h"

@interface FlareAwareViewController ()

@end

@implementation FlareAwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.startButton.tag = 1;
    
    // Configure SIDE engine and register listener
    [self sideEngineConfigure];
}

- (IBAction)startPressed:(UIButton *)button {
    if (self.startButton.tag == 1) {
        // It is possible to activate the distance filter in order to transmit location data in the Flare aware network. This will ensure that location updates are transmitted every 20 meters, once the timer interval has been reached.
        self.sideEngineShared.distance_filter_meters = 20;
        
        // The default value is 15 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = false" is invoked.
        self.sideEngineShared.low_frequency_intervals_seconds = 15;
        
        // The default value is 3 seconds, which can be adjusted to meet specific requirements. This parameter will only be utilized in cases where "sideEngineShared.high_frequency_mode_enabled = true" is invoked.
        self.sideEngineShared.high_frequency_intervals_seconds = 3;
        
        // It is recommended to activate the high frequency mode when the startFlareAware() function is engaged in order to enhance the quality of the Fleet users experience.
        self.sideEngineShared.high_frequency_mode_enabled = YES;
        
        [self.sideEngineShared startFlareAware];
    } else {
        [self.sideEngineShared stopFlareAware];
    }
}

- (void)sideEngineConfigure {
    BBSideEngineManager *shared = [BBSideEngineManager shared];
    
    /****How to configure production mode****/
    // Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
    // Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
    
    // NSString *accessKey = @"Your production license key here";
    BBMode mode = BBModeProduction;
//    NSString *accessKey = @"Your production license key here";
    NSString *accessKey = @"8b53824f-ed7a-4829-860b-f6161c568fad" ;

    [shared configureWithAccessKey:accessKey mode:mode theme:BBThemeStandard];
    
    // Register SIDE engine listener here
    [self registerSideEngineListener];
}

- (void)registerSideEngineListener {
    __weak typeof(self) weakSelf = self;
    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse *response) {
        typeof(self) strongSelf = weakSelf;
        
        if (response.type == BBSideOperationConfigure && response.success) {
            // You are now able to initiate the SIDE engine process at any time. In the event that there is no user input button available to commence the activity, you may commence the SIDE engine by executing the following command:
            NSLog(@"CONFIGURE with status: %@", response.success ? @"true" : @"false");
        } else if (response.type == BBSideOperationStartFlareAware) {
            // Update your UI here (e.g. update START button color or text here when SIDE engine started)
            NSLog(@"START Flare Aware live mode with status: %@", response.success ? @"true" : @"false");
            
            if (response.success) {
                strongSelf.startButton.tag = 2;
                [strongSelf.startButton setTitle:@"STOP Flare Aware" forState:UIControlStateNormal];
                strongSelf.startButton.backgroundColor = [UIColor redColor];
            } else {
                // Handle error message here
                NSLog(@"Error message: %@", response.payload);
            }
        } else if (response.type == BBSideOperationStopFlareAware && response.success) {
            // Update your UI here (e.g. update STOP button color or text here when SIDE engine stopped)
            NSLog(@"STOP live mode with status: %@", response.success ? @"true" : @"false");
            strongSelf.startButton.tag = 1;
            [strongSelf.startButton setTitle:@"START Flare Aware" forState:UIControlStateNormal];
            strongSelf.startButton.backgroundColor = [UIColor systemGreenColor];
        }
    }];
    
}

@end
