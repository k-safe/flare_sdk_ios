//
//  CustomCountDownViewController.h
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import <UIKit/UIKit.h>
#import "TestSideEngineSupportViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BBSideEngine/BBSideEngine.h"


@protocol CustomTimerDelegate <NSObject>
- (void)didFinishTimer;
@end



@interface CustomCountDownViewController : UIViewController
 

@property (nonatomic, weak) id<CustomTimerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *mainTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondsLabel;
@property (nonatomic, weak) IBOutlet UILabel *countDownLabel;

@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, strong) NSTimer *counterTimer;

- (IBAction)closeTapped;
- (void)cancelAutoIncident;

/**
 @IBOutlet var mainTitleLabel : UILabel!
 @IBOutlet var secondsLabel : UILabel!
 @IBOutlet var countDownLabel : UILabel!
 
 //Handle countdown timer
 var counter = BBSideEngineManager.shared.countDownDuration
 var counterTimer : Timer!
 */
@end



 
