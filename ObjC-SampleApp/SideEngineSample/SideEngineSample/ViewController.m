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
@synthesize sandboxButton,productionButton;
- (void)viewDidLoad {
     [self configureUI];
}

- (void)configureUI {
    [self.sandboxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.sandboxButton setImage:[UIImage imageNamed:@"un_checked"] forState:UIControlStateNormal];
    
    [self.productionButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [self.productionButton setImage:[UIImage imageNamed:@"un_checked"] forState:UIControlStateNormal];
    
    [self initConfigure];
}

- (void)initConfigure {
    self.isProductionMode = NO;
    self.sandboxButton.selected = YES;
    self.productionButton.selected = NO;
}

- (IBAction)updateModeTapped:(UIButton *)button {
    if (button.tag == 1) {
        self.sandboxButton.selected = YES;
        self.productionButton.selected = NO;
        self.isProductionMode = NO;
    } else if (button.tag == 2) {
        self.sandboxButton.selected = NO;
        self.productionButton.selected = YES;
        self.isProductionMode = YES;
    }
}

- (IBAction)standardButtonTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StandardThemeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"StandardThemeViewController"];
    controller.isProductionMode = self.isProductionMode;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)customButtonTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomThemeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CustomThemeViewController"];
    controller.isProductionMode = self.isProductionMode;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)sosButtonTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EmergencySOSViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"EmergencySOSViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)flareAwareTapped {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FlareAwareViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FlareAwareViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
