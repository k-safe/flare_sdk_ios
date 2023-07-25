//
//  StandardThemeViewController.h
//  SideEngineSample
//
//  Created by Phoenix Innovate on 07/11/22.
//

#import <UIKit/UIKit.h>
#import <BBSideEngine/BBSideEngine.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface StandardThemeViewController : UIViewController {
    
}
@property (nonatomic, strong) BBSideEngineManager *sideEngineShared;
@property (nonatomic) BOOL isProductionMode;
@property (nonatomic, weak) IBOutlet UITextField *countryCode;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumber;
@property (nonatomic, weak) IBOutlet UITextField *riderName;
@property (nonatomic, weak) IBOutlet UITextField *riderEmail;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UILabel *confidenceLabel;


@end

NS_ASSUME_NONNULL_END
 
