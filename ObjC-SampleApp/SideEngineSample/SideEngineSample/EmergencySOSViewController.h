//
//  EmergencySOSViewController.h
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <BBSideEngine/BBSideEngine.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmergencySOSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnActivate;
@property (weak, nonatomic) IBOutlet UITextField *riderName;

@property (strong, nonatomic) BBSideEngineManager *sideEngineShared;
@property (strong, nonatomic) NSString *shareLink;

- (IBAction)btnSOSAction:(id)sender;
- (IBAction)btnShare:(id)sender;

@end

NS_ASSUME_NONNULL_END
