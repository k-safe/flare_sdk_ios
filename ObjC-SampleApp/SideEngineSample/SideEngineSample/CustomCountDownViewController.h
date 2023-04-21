//
//  CustomCountDownViewController.h
//  SideEngineSample
//
//  Created by PhoenixiOS-1 on 17/11/22.
//

#import <UIKit/UIKit.h>
#import "TestViewModeController.h"
#import "TestSideEngineSupportViewController.h"

@import AVFoundation;
@import AudioToolbox;
@import BBSideEngine;

NS_ASSUME_NONNULL_BEGIN

@interface CustomCountDownViewController : UIViewController
{
    
}

@property(nonatomic, weak) IBOutlet UILabel *mainTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *secondsLabel;
@property(nonatomic, weak) IBOutlet UILabel *countDownLabel;
@property(nonatomic, strong) NSTimer *counterTimer;
@property(nonatomic, assign) NSInteger counter;

- (IBAction)closeTapped:(UIButton *)sender;
-(void)runTimer:(NSTimer *)timer;
-(void)stopTimer:(BOOL)finished;
-(void)openSupportScreen;
-(void)configureTimer;
/**
 @IBOutlet var mainTitleLabel : UILabel!
 @IBOutlet var secondsLabel : UILabel!
 @IBOutlet var countDownLabel : UILabel!
 
 //Handle countdown timer
 var counter = BBSideEngineManager.shared.countDownDuration
 var counterTimer : Timer!
 */
@end

NS_ASSUME_NONNULL_END
