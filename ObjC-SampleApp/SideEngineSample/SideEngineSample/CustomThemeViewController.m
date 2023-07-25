//
//  CustomThemeViewController.m
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import "CustomThemeViewController.h"
#import <BBSideEngine/BBSideEngine.h>
@import BBSideEngine;

@interface CustomThemeViewController () <CustomTimerDelegate>
@property (nonatomic, strong) CustomCountDownViewController *customUIController;

@end
@implementation CustomThemeViewController;

@synthesize countryCode,phoneNumber,riderName,riderEmail,startButton,confidenceLabel,sideEngineShared;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.confidenceLabel.text = @"";
    self.startButton.tag = 1;
    
    // Configure SIDE engine and register listener
    [self sideEngineConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)sideEngineConfigure {
    self.sideEngineShared = [BBSideEngineManager shared];
    
    // Configure production mode or sandbox mode
    BBMode mode = self.isProductionMode ? BBModeProduction : BBModeSandbox;
    NSString *accessKey = self.isProductionMode ? @"Your production license key here" : @"Your sandbox license key here";

    [self.sideEngineShared configureWithAccessKey:accessKey mode:mode theme:BBThemeCustom];
    
    // Register SIDE engine listener
    [self registerSideEngineListener];
}

- (IBAction)startPressed:(UIButton *)button {
    // Start and stop SIDE engine
    if (self.startButton.tag == 1) {
        self.sideEngineShared.riderName = self.riderName.text;
        self.sideEngineShared.riderEmail = self.riderEmail.text;
        self.sideEngineShared.riderId = [self uniqueId];
        self.sideEngineShared.countDownDuration = 30;
        self.sideEngineShared.showLog = YES;
        
        self.sideEngineShared.enable_flare_aware_network = NO;
        self.sideEngineShared.distance_filter_meters = 20;
        self.sideEngineShared.low_frequency_intervals_seconds = 15;
        self.sideEngineShared.high_frequency_intervals_seconds = 3;
        self.sideEngineShared.high_frequency_mode_enabled = NO;
        
        [self.sideEngineShared startSideEngine];
    } else {
        [self.sideEngineShared stopSideEngine];
    }
}

- (void)registerSideEngineListener {
    __weak typeof(self) weakSelf = self;
    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse * response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (response.type == BBSideOperationConfigure && response.success == YES) {
            // SIDE engine configured successfully
        } else if (response.type == BBSideOperationStart && response.success == YES) {
            // SIDE engine started successfully
            strongSelf.startButton.tag = 2;
            [strongSelf.startButton setTitle:@"STOP" forState:UIControlStateNormal];
            strongSelf.startButton.backgroundColor = [UIColor redColor];
        } else if (response.type == BBSideOperationStop && response.success == YES) {
            // SIDE engine stopped successfully
            strongSelf.startButton.tag = 1;
            [strongSelf.startButton setTitle:@"START" forState:UIControlStateNormal];
            strongSelf.startButton.backgroundColor = [UIColor systemGreenColor];
        } else if (response.type == BBSideOperationIncidentDetected) {
            // Incident detected
            NSNumber *confidence = response.payload[@"confidence"];
            NSLog(@"SIDE engine confidence is: %@", confidence);
            strongSelf.confidenceLabel.text = [NSString stringWithFormat:@"SIDE confidence is: %@", confidence];
            
            if (strongSelf.sideEngineShared.applicationTheme == BBThemeCustom) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CustomCountDownViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CustomCountDownViewController"];
                controller.delegate = strongSelf;
                strongSelf.customUIController = controller;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIApplicationState state = [UIApplication sharedApplication].applicationState;
                    if (state != UIApplicationStateActive) {
                        [strongSelf presentViewController:controller animated:YES completion:nil];
                    } else {
                        [strongSelf.navigationController pushViewController:controller animated:NO];
                    }
                });
            }
        } else if (response.type == BBSideOperationIncidentAutoCancel) {
            // Incident auto-cancelled
            [strongSelf.customUIController cancelAutoIncident];
        } else if (response.type == BBSideOperationIncidentAlertSent) {
            // Incident alert sent
        } else if (response.type == BBSideOperationSms) {
            // SMS sent
        } else if (response.type == BBSideOperationEmail) {
            // Email sent
        } else if (response.type == BBSideOperationResumeSideEngine) {
            // SIDE engine resumed
        } else if (response.type == BBSideOperationLocation) {
            // User's location update
//            CLLocation *location = response.payload[@"location"];
            // Process location update
        }
    }];
}

- (void)sendSMS {
    if (self.countryCode.text.length > 0 && self.phoneNumber.text.length > 0) {
        NSDictionary *contact = @{
            @"countryCode": self.countryCode.text,
            @"phoneNumber": self.phoneNumber.text,
            @"username": self.riderName.text
        };
        
        [self.sideEngineShared sendSMSWithContact:contact];
    }
}

- (void)sendEmail {
    if (self.riderEmail.text.length > 0) {
        [self.sideEngineShared sendEmailToEmail:self.riderEmail.text];
    }
}

- (NSString *)uniqueId {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

#pragma mark - CustomTimerDelegate

- (void)didFinishTimer {
    [self sendEmail];
    [self sendSMS];
}

@end
