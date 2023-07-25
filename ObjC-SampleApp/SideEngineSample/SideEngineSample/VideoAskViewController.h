//
//  VideoAskViewController.h
//  SideEngineSample
//
//  Created by Phoenix@TNM#Mac on 07/07/23.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <BBSideEngine/BBSideEngine.h>
#import <WebKit/WebKit.h>
@import BBSideEngine;

@protocol VideoAskDelegate <NSObject>
- (void)didFinishSurvey;
@end

NS_ASSUME_NONNULL_BEGIN

@interface VideoAskViewController : UIViewController
@property (nonatomic, weak) id<VideoAskDelegate> delegate;
@property (nonatomic, weak) IBOutlet WKWebView *webview;

@end

NS_ASSUME_NONNULL_END
