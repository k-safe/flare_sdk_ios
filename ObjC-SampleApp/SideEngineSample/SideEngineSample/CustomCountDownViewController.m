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
    self.counter = [[BBSideEngineManager shared] countDownDuration];
    [self configureTimer];
}

- (IBAction)closeTapped {
    [self stopTimerWithFinished:NO];
    [[BBSideEngineManager shared] resumeSideEngine];
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelAutoIncident {
    if (self.counterTimer) {
        [self.counterTimer invalidate];
        self.counterTimer = nil;
    }
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)configureTimer {
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld", (long)self.counter];
    self.counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
}

- (void)openSupportScreen {
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state != UIApplicationStateActive || [self isModal]) {
        [self closeTapped];
    } else {
        if (self.delegate) {
            [self.delegate didFinishTimer];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TestSideEngineSupportViewController *testViewController = [storyboard instantiateViewControllerWithIdentifier:@"TestSideEngineSupportViewController"];
            [self.navigationController pushViewController:testViewController animated:YES];
        });
    }
}

- (void)runTimer {
    self.counter--;
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld", (long)self.counter];
    if (self.counter >= 0) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    if (self.counter <= 0) {
        [self stopTimerWithFinished:YES];
    }
}

- (void)stopTimerWithFinished:(BOOL)finished {
    self.countDownLabel.text = @"0";
    self.counter = 0;
    if (self.counterTimer) {
        [self.counterTimer invalidate];
        self.counterTimer = nil;
    }
    if (finished) {
        [[BBSideEngineManager shared] notifyPartner];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openSupportScreen];
        });
    }
}

- (BOOL)isModal {
    BOOL presentingIsModal = self.presentingViewController != nil;
    BOOL presentingIsNavigation = self.navigationController.presentingViewController.presentedViewController == self.navigationController;
    BOOL presentingIsTabBar = [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
    return presentingIsModal || presentingIsNavigation || presentingIsTabBar;
}

@end
