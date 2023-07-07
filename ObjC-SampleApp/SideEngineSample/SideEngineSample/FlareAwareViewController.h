//
//  FlareAwareViewController.h
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import <UIKit/UIKit.h>
#import "BBSideEngine/BBSideEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlareAwareViewController : UIViewController
@property (nonatomic, strong) BBSideEngineManager *sideEngineShared;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, assign) BOOL isProductionMode;

@end

NS_ASSUME_NONNULL_END
 
