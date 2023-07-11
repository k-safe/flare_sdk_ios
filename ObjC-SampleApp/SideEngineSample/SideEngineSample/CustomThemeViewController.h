//
//  CustomThemeViewController.h
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import <UIKit/UIKit.h>
#import "CustomCountDownViewController.h"
#import "BBSideEngine/BBSideEngine-Swift.h"
NS_ASSUME_NONNULL_BEGIN

@import BBSideEngine;

@interface CustomThemeViewController : UIViewController

 
@property (nonatomic, strong) BBSideEngineManager *sideEngineShared;
@property (nonatomic, assign) BOOL isProductionMode;
@property (nonatomic, weak) IBOutlet UITextField *countryCode;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *riderName;
@property (nonatomic, weak) IBOutlet UITextField *riderEmail;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UILabel *confidenceLabel;
 
@end




NS_ASSUME_NONNULL_END

