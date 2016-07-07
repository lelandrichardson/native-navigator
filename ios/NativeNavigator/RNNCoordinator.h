#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RNNViewController;
@protocol RNNCoordinatorDelegate;
@class RCTBridge;


@interface RNNCoordinator : NSObject

+ (instancetype)sharedInstance;

@property (weak, nonatomic) id<RNNCoordinatorDelegate> delegate;
@property (strong, nonatomic) RCTBridge *bridge;

- (void)registerViewController:(Class)classObj withName:(NSString *)name;
- (UIViewController *)nativeViewControllerFromName:(NSString *)name withProps:(NSDictionary *)props;

- (void)unregisterRNViewController:(NSString *)viewControllerId;
- (void)registerRNViewController:(RNNViewController *)viewController;
//- (RNNViewController *)top;
- (RNNViewController *)viewControllerWithId:(NSString *)id;
- (RNNViewController *)newViewController:(NSString *)moduleName withProps:(NSDictionary *)props;
- (UIViewController *)topViewController;
- (UITabBarController *)topTabBarController;
- (UINavigationController *)topNavigationController;

@end