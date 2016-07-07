#import <Foundation/Foundation.h>

@class RNNCoordinator;

@protocol RNNCoordinatorDelegate <NSObject>

- (UIViewController *)rootControllerForCoordinator:(RNNCoordinator *)coordinator;
- (UIViewController *)nativeViewControllerFromName:(NSString *)name withProps:(NSDictionary *)props;

@optional

@end