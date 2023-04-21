//
//  CustomCountDownViewController.m
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import "CustomCountDownViewController.h"

@interface CustomCountDownViewController ()

@end

@implementation CustomCountDownViewController
@synthesize mainTitleLabel,secondsLabel,countDownLabel,counter,counterTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.counter = [[BBSideEngineManager shared] countDownDuration];
    [self configureTimer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)closeTapped:(UIButton *)sender {
    [self stopTimer:NO];
    [[BBSideEngineManager shared] resumeSideEngine];//You need to resume side engine when go to back screen
    [self.navigationController popViewControllerAnimated:YES];
}

//TODO: Configure Timer
-(void)configureTimer {
    [self.countDownLabel setText:[NSString stringWithFormat:@"0"]];
    self.counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}
//TODO: Support screen
-(void)openSupportScreen {
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TestSideEngineSupportViewController *testSideEngineSupport = [storyBoard instantiateViewControllerWithIdentifier:@"TestSideEngineSupportViewController"];
        [self.navigationController pushViewController:testSideEngineSupport animated:YES];
    });
}
//MARK: **************Start count down timer**************
-(void)runTimer:(NSTimer *)timer {
    counter = counter - 1;
    [self.countDownLabel setText:[NSString stringWithFormat:@"%ld",(long)counter]];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    if (counter == 0) {
        [self stopTimer:YES];
    }
}
-(void)stopTimer:(BOOL)finished {
    self.counter = 0;
    [self.countDownLabel setText:[NSString stringWithFormat:@"%ld",(long)counter]];
    if (self.counterTimer != nil) {
        [self.counterTimer invalidate];
        //self.counterTimer = nil;
        //self.counterTimer = nil;
    }
    
    if (finished == YES) {
        if ([[BBSideEngineManager shared] sideEngineMode] == BBSideEngineModeLive) {
            [[BBSideEngineManager shared] notifyPartner];
        }
        [self openSupportScreen];
    }
}


@end
