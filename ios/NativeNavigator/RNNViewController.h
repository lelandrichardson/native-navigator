#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"

@class RCTBridge;
@class RCTRootView;

@interface RNNViewController : UIViewController

- (instancetype)initWithBridge:(RCTBridge *)bridge
                     andModule:(NSString *)moduleName
                      andProps:(NSDictionary *)props;

@property (strong, nonatomic) RCTBridge *bridge;
@property (strong, nonatomic) NSString *moduleName;
@property (strong, nonatomic) NSDictionary *props;
@property (strong, nonatomic) RCTRootView *rootView;
@property (strong, readonly) NSString *viewControllerId;

@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL statusBarHidden;
@property (nonatomic) UIStatusBarAnimation statusBarUpdateAnimation;

- (void)setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated;
- (void)setStatusBarHidden:(BOOL)hidden animation:(UIStatusBarAnimation)animation;

@end