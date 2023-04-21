//
//  StandardThemeViewController.h
//  SideEngineSample
//
//  Created by Phoenix Innovate on 07/11/22.
//

#import <UIKit/UIKit.h>

#import "TestViewModeController.h"
#import <BBSideEngine/BBSideEngine.h>
//@import BBSideEngine;
NS_ASSUME_NONNULL_BEGIN




@interface StandardThemeViewController : UIViewController {
    
    //typedef void (^callbackHelper) (BBResponse * response);
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

