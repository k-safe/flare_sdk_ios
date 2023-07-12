//  StandardThemeViewController.m
//  SideEngineSample
//
//  Created by Phoenix Innovate on 07/11/22.
//

#import "StandardThemeViewController.h"
#import <BBSideEngine/BBSideEngine.h>

@interface StandardThemeViewController ()

@end

@implementation StandardThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confidenceLabel.text = @"";
    self.startButton.tag = 1;
    
    // Configure SIDE engine and register listener
    [self sideEngineConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// Configure SIDE engine and register listener
- (void)sideEngineConfigure {
    self.sideEngineShared = [BBSideEngineManager shared];

    // How to configure production mode
    BBMode mode = self.isProductionMode ? BBModeProduction : BBModeSandbox;
    NSString *accessKey = self.isProductionMode ? @"Your production license key here" : @"Your sandbox license key here";
    [self.sideEngineShared configureWithAccessKey:accessKey mode:mode theme:BBThemeStandard];
    
    // Register SIDE engine listener
    [self registerSideEngineListener];
}

- (IBAction)startPressed:(UIButton *)button {
    // Start and Stop SIDE engine
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
        
        // Start SIDE engine
        [self.sideEngineShared startSideEngine];
    } else {
        // stopSideEngine will stop all the services inside SIDE engine and release all the variables
        [self.sideEngineShared stopSideEngine];
    }
}

// Register SIDE engine listener to receive callback from SIDE engine
- (void)registerSideEngineListener {
    __weak typeof(self) weakSelf = self;
    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse * response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (response.type == BBSideOperationConfigure && response.success == YES) {
            NSLog(@"CONFIGURE with status: %d", response.success);
        } else if (response.type == BBSideOperationStart) {
            NSLog(@"START live mode with status: %d", response.success);
            
            if (response.success == YES) {
                strongSelf.startButton.tag = 2;
                [strongSelf.startButton setTitle:@"STOP" forState:UIControlStateNormal];
                strongSelf.startButton.backgroundColor = [UIColor redColor];
            } else {
                NSLog(@"Error message: %@", response.payload);
            }
        } else if (response.type == BBSideOperationStop && response.success == YES) {
            NSLog(@"STOP live mode with status: %d", response.success);
            strongSelf.startButton.tag = 1;
            [strongSelf.startButton setTitle:@"START" forState:UIControlStateNormal];
            strongSelf.startButton.backgroundColor = [UIColor systemGreenColor];
        } else if (response.type == BBSideOperationIncidentDetected) {
            if (strongSelf.isProductionMode == YES) {
                NSNumber *confidence = response.payload[@"confidence"];
                NSLog(@"SIDE engine confidence is: %@", confidence);
                strongSelf.confidenceLabel.text = [NSString stringWithFormat:@"SIDE confidence is: %@", confidence];
            } else {
                strongSelf.confidenceLabel.text = @"";
            }
        } else if (response.type == BBSideOperationIncidentCancel) {
            // The incident has been automatically cancelled.
        } else if (response.type == BBSideOperationTimerStarted) {
            // A 30-second countdown timer has started.
        } else if (response.type == BBSideOperationTimerFinished) {
            // After the 30-second timer ended.
            [strongSelf sendSMS];
            [strongSelf sendEmail];
        } else if (response.type == BBSideOperationIncidentAutoCancel) {
            // The incident has been automatically cancelled.
        } else if (response.type == BBSideOperationIncidentAlertSent) {
            // Return the alert sent.
        } else if (response.type == BBSideOperationSms) {
            // Returns SMS delivery status and response payload.
        } else if (response.type == BBSideOperationEmail) {
            // Returns email delivery status and response payload.
        } else if (response.type == BBSideOperationLocation) {
            // You will receive the user's location update status in this location.
        } else if (response.type == BBSideOperationOpenVideoSurvey) {
            // In the event that your partner has set up a video survey of the user following an incident detection.
        } else if (response.type == BBSideOperationCloseVideoSurvey) {
            // The user has submitted a video survey.
        } else if (response.type == BBSideOperationIncidentVerifiedByUser) {
            // The user has confirmed that the incident is accurate.
        } else if (response.type == BBSideOperationResumeSideEngine) {
            // The user has confirmed that the incident is accurate.
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

// Generate random uniqueID
- (NSString *)uniqueId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end

