//
//  ViewController.h
//  SideEngineSample
//
//  Created by Phoenix Innovate on 07/11/22.
//

#import <UIKit/UIKit.h>
#import "StandardThemeViewController.h"
#import "CustomThemeViewController.h"
#import "FlareAwareViewController.h"
#import "EmergencySOSViewController.h"


@interface ViewController :UIViewController{
    
}

@property (nonatomic, assign) BOOL isProductionMode;
@property (nonatomic, weak) IBOutlet UIButton *productionButton;
@property (nonatomic, weak) IBOutlet UIButton *sandboxButton;

- (void)configureUI;
- (void)initConfigure;
- (IBAction)updateModeTapped:(UIButton *)button;
- (IBAction)standardButtonTapped;
- (IBAction)customButtonTapped;
- (IBAction)sosButtonTapped;
- (IBAction)flareAwareTapped;
@end
 
