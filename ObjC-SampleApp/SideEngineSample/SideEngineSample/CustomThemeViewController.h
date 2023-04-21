//
//  CustomThemeViewController.h
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import <UIKit/UIKit.h>
#import "CustomCountDownViewController.h"

@import BBSideEngine;
NS_ASSUME_NONNULL_BEGIN

@interface CustomThemeViewController : UIViewController
{
    
}

@property(nonatomic, weak) IBOutlet UITextField *countryCode;
@property(nonatomic, weak) IBOutlet UITextField *phoneNumber;
@property(nonatomic, weak) IBOutlet UITextField *riderName;
@property(nonatomic, weak) IBOutlet UITextField *riderEmail;
@property(nonatomic, weak) IBOutlet UIButton *startButton;
@property(nonatomic, weak) IBOutlet UILabel *confidenceLabel;

@property(nonatomic, weak) BBSideEngineManager *sideEngineShared;

- (IBAction)startPressed:(UIButton *)sender;
- (IBAction)testModePressed:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
