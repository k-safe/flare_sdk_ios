//
//  TestViewModeController.m
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import "TestViewModeController.h"

@interface TestViewModeController ()

@end

@implementation TestViewModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)backToHome {
    [[BBSideEngineManager shared] resumeSideEngine];
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)closeTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
