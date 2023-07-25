//
//  VideoAskViewController.m
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import "VideoAskViewController.h"

@interface VideoAskViewController ()

@end

@implementation VideoAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // If video survey enable in the your partner
    if ([NSURL URLWithString:[BBSideEngineManager shared].surveyVideoURL]) {
        NSURLRequest *myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[BBSideEngineManager shared].surveyVideoURL]];
        [self.webview loadRequest:myRequest];
    }
}

- (IBAction)closeTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to end this survey?" preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"End" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate != nil) {
            [self.delegate didFinishSurvey];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
