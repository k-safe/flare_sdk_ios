//
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
@synthesize countryCode,phoneNumber,riderName,riderEmail,startButton,confidenceLabel,sideEngineShared;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self.confidenceLabel setText:@""];
    
    [self.startButton setTag:1];
    [self sideEngineConfigure];
    //SIDE Engine
//        sideEngineShared.applicationTheme = .standard //You can update your theme here,this will override your configure method theme
    
    //Configure SIDE engine and register listner
    //self.sideEngineConfigure()
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)startPressed:(UIButton *)sender {
    //Start and Stop SIDE engine
    if ([self.startButton tag] == 1) {
        [self.sideEngineShared setRiderName:self.riderName.text];
        [self.sideEngineShared setRiderEmail:self.riderEmail.text];
        [self.sideEngineShared setRiderId:[self uniqueId]];
        [self.sideEngineShared setCountDownDuration:30];// for live mode
        [self.sideEngineShared setShowLog:YES]; //Default true //false when release app to the store
        
        //You can update below parameters if require
//        [self.sideEngineShared setBackgroundColor:UIColor.redColor];//Only for standard theme
//        [self.sideEngineShared setContentTextColor:UIColor.blueColor];//Only for standard theme
//        [self.sideEngineShared setSwipeToCancelTextColor:UIColor.yellowColor];//Only for standard theme
//        [self.sideEngineShared setSwipeToCancelBackgroundColor:UIColor.grayColor];//Only for standard theme
//        [self.sideEngineShared setImpactBody:@"Detected a potential fall or impect involving"];//This message show in the SMS, email, webook and slack body with the rider name passed in the section:7 (shared.riderName) parameter
        
        //Start SIDE engine
        [self.sideEngineShared startSideEngineWithMode:BBSideEngineModeLive];
        
//        //Register SIDE engine listener here
//        [self registerSideEngineListener];
        //
    }else {
        //stopSideEngine will stop all the services inside SIDE engine and release all the varibales
        [self.sideEngineShared stopSideEngine];
    }
}
- (IBAction)testModePressed:(UIButton *)sender {
    
    [self.sideEngineShared setRiderName:self.riderName.text];
    [self.sideEngineShared setRiderEmail:self.riderEmail.text];
    [self.sideEngineShared setRiderId:[self uniqueId]];
    [self.sideEngineShared setCountDownDuration:5];// for test mode
    [self.sideEngineShared setShowLog:YES]; //Default true //false when release app to the store
    
    //Start SIDE engine
    [self.sideEngineShared startSideEngineWithMode:BBSideEngineModeTest];
    
    //MARK: Test incident scenario
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TestViewModeController *testViewModeController = [storyboard instantiateViewControllerWithIdentifier:@"TestViewModeController"];
//    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse * response) {
//        if (response) {
//            if (response) {
//
//            }
//        }
//    }];
//    [self.navigationController pushViewController:testViewModeController animated:YES];
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let testViewModeController = storyBoard.instantiateViewController(withIdentifier: "TestViewModeController") as! TestViewModeController
//        sideEngineShared.sideEventsListener { (response) in
//            if response.type == .incidentDetected {
////                testViewModeController.backToHome() // require for back to root view
//            }
//        }
//        self.navigationController?.pushViewController(testViewModeController, animated: true)
}


//TODO: Configure SIDE engine and register listner
- (void)sideEngineConfigure {
    self.sideEngineShared = [BBSideEngineManager shared];
    
    //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
//        shared.configure(accessKey: "Your license key here", mode: .sandbox, theme: .standard)
    
    /****How to configure production mode****/
    //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
    [self.sideEngineShared configureWithAccessKey:@"c0978e03-8883-4a39-8d40-9de222401ef8" mode:BBModeProduction theme:BBThemeStandard];//
    
    [self registerSideEngineListener];
}
//TODO: Register SIDE engine listener to receive call back from side engine
- (void)registerSideEngineListener {
   
    [self.sideEngineShared sideEventsListenerWithHandler:^(BBResponse * response) {
        switch ([response type]) {
            case BBSideOperationConfigure:
                if ([response success] == YES) {
                    //Now you can ready to start SIDE engine process, if you dont have user input button to start activity then you can start SIDE engine here: sideEngineShared.startSideEngine(mode: .live)
                    NSLog(@"CONFIGURE with status: %d",[response success]);
                }else {
                    NSLog(@"CONFIGURE with status: %d",[response success]);
                }
                break;
            case BBSideOperationStart:
                //Update your UI here (e.g. update START button color or text here when SIDE engine started)
                if (self.sideEngineShared.sideEngineMode == BBSideEngineModeLive) {
                    NSLog(@"START live mode with status: %d",[response success]);
                    if ([response success] == YES) {
                        [self.startButton setTag:2];
                        [self.startButton setTitle:@"STOP" forState:UIControlStateNormal];
                        [self.startButton setBackgroundColor:UIColor.redColor];
                    } else {
                        NSLog(@"Error message: %@",[[response payload] description]);
                    }
                } else {
                    NSLog(@"START test mode with status: %d",[response success]);
                }
                break;
            case BBSideOperationStop:
                if ([response success] == YES) {
                    if ([self.sideEngineShared sideEngineMode] == BBSideEngineModeLive) {
                        [self.startButton setTag:1];
                        [self.startButton setTitle:@"START" forState:UIControlStateNormal];
                        [self.startButton setBackgroundColor:UIColor.systemGreenColor];
                    } else {
                        NSLog(@"STOP test mode with status:%d",[response success]);
                    }
                }
                break;
            case BBSideOperationIncidentDetected:
                NSLog(@"INCIDENT DETECTED with status: %d",[response success]);
                //Threshold reached and you will redirect to countdown page
                //Return incident status and confidence level, you can fetch confidance using the below code:
                if ([self.sideEngineShared sideEngineMode] == BBSideEngineModeLive) {
                    NSString *confidance = [[response payload] objectForKey:@"confidence"];
                    [self.confidenceLabel setText:[NSString stringWithFormat:@"SIDE confidence is: %@",confidance]];
                    NSLog(@"SIDE engine confidence is: %@",confidance);
                }
                else {
                    //Test mode not return confidence
                    [self.confidenceLabel setText:@""];
                }
                
                //Send SMS or Email code here to notify your emergency contact (Github example for sample code)
//                [self sendSMS];
//                if ([self.riderEmail.text isEqualToString:@""] == NO) {
//                    [self.sideEngineShared sendEmailToEmail:[NSString stringWithFormat:@"%@",[self.riderEmail text]]];
//                }
                break;
            case BBSideOperationIncidentCancel:
                //User canceled countdown countdown to get event here, this called only if you configured standard theme.
                break;
            case BBSideOperationTimerStarted:
                //Countdown timer started after breach delay, this called only if you configured standard theme.
                break;
            case BBSideOperationTimerFinished:
                //Countdown timer finished and jump to the incident summary page, this called only if you configured standard theme.
                break;
            case BBSideOperationIncidentAlertSent:
                //Return the alert sent (returns alert details (i.e. time, location, recipient, success/failure))
                break;
            case BBSideOperationSms:
                //Returns SMS delivery status and response payload
                break;
            case BBSideOperationEmail:
                //Returns email delivery status and response payload
                break;
            case BBSideOperationLocation:
                //Returns CLLocation object
                break;
            default:
                break;
        }
//        if ([response type] == BBSideOperationConfigure) {
//
//        }
    }];

}

- (void)sendSMS {

    if (([self.countryCode.text isEqualToString:@""] == NO) && ([self.phoneNumber.text isEqualToString:@""] == NO) ) {

        NSMutableDictionary *contact = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.countryCode.text],@"countryCode",[NSString stringWithFormat:@"%@",self.phoneNumber.text],@"phoneNumber",[NSString stringWithFormat:@"%@",self.riderName.text],@"username", nil];
        
        //NSMutableArray *contact = [@"countryCode":[NSString stringWithFormat:@"%@",self.countryCode.text], @"phoneNumber" : [NSString stringWithFormat:@"%@",self.phoneNumber.text], @"username":[NSString stringWithFormat:@"%@",self.riderName.text]]
        [self.sideEngineShared sendSMSWithContact:contact];
    }
}

- (NSString *)uniqueId {
     return  [[UIDevice currentDevice] identifierForVendor].UUIDString
}

 
//TODO: Register SIDE engine listener to receive call back from side engine
/*

*/
//func sideEngineConfigure() {
//    let shared = BBSideEngineManager.shared
//
//    //Sandbox mode used only for while developing your App (You can use any of the one theme e.g. .standard OR .custom)
////        shared.configure(accessKey: "Your license key here", mode: .sandbox, theme: .standard)
//
//    /****How to configure production mode****/
//    //Production mode used when you release app to the app store (You can use any of the one theme e.g. .standard OR .custom)
//    shared.configure(accessKey: "c0978e03-8883-4a39-8d40-9de222401ef8", mode: .production, theme: .standard)
//
//    //Register SIDE engine listener here
//    self.registerSideEngineListener()
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
