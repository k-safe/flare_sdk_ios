//
//  ViewController.m
//  SideEngineSample
//
//  Created by Phoenix Innovate on 07/11/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(IBAction)standardButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//[[UIStoryboard alloc] instantiateInitialViewControllerWithCreator:@""];
    StandardThemeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StandardThemeViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)customButtonTapped:(id)sender {
    NSLog(@"Custom tapped");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//[[UIStoryboard alloc] instantiateInitialViewControllerWithCreator:@""];
    CustomThemeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CustomThemeViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
