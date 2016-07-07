#import "RNNNavigatorModule.h"
#import "RNNCoordinator.h"
#import "RNNViewController.h"

@implementation RNNNavigatorModule {

}

RCT_EXPORT_MODULE()

#pragma mark Scene Attributes


RCT_EXPORT_METHOD(setTitle:(NSString *)id withTitle:(NSString *)title)
{
  NSLog(@"setTitle: %@ => %@", id, title);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNViewController *vc = [[RNNCoordinator sharedInstance] viewControllerWithId:id];
    [vc setTitle:title];
  });
}

RCT_EXPORT_METHOD(setRightTitle:(NSString *)id withTitle:(NSString *)title)
{
  NSLog(@"setRightTitle: %@ => %@", id, title);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNViewController *vc = [[RNNCoordinator sharedInstance] viewControllerWithId:id];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
      initWithTitle:title
              style:UIBarButtonItemStylePlain
             target:vc
             action:@selector(barButtonItemPressed)];
    vc.navigationItem.rightBarButtonItem = item;
  });
}








#pragma mark Transitions

RCT_EXPORT_METHOD(push:(NSString *)screenName withProps:(NSDictionary *)props animated:(BOOL)animated)
{
  NSLog(@"push: %@", screenName);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    RNNViewController *pushed = [coordinator newViewController:screenName withProps:props];
    [[coordinator topNavigationController] pushViewController:pushed animated:animated];
  });
}

RCT_EXPORT_METHOD(pushNative:(NSString *)name withProps:(NSDictionary *)props animated:(BOOL)animated)
{
  NSLog(@"pushNative: %@", name);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    UIViewController *pushed = [coordinator nativeViewControllerFromName:name withProps:props];
    [[coordinator topNavigationController] pushViewController:pushed animated:animated];
  });
}

RCT_EXPORT_METHOD(present:(NSString *)screenName withProps:(NSDictionary *)props animated:(BOOL)animated)
{
  NSLog(@"present: %@", screenName);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    RNNViewController *presented = [coordinator newViewController:screenName withProps:props];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:presented];
    [[coordinator topNavigationController] presentViewController:nav animated:animated completion:nil];
  });
}

RCT_EXPORT_METHOD(presentNative:(NSString *)name withProps:(NSDictionary *)props animated:(BOOL)animated)
{
  NSLog(@"presentNative: %@", name);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    UIViewController *presented = [coordinator nativeViewControllerFromName:name withProps:props];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:presented];
    [[coordinator topNavigationController] presentViewController:nav animated:animated completion:nil];
  });
}

RCT_EXPORT_METHOD(dismiss:(NSDictionary *)payload animated:(BOOL)animated)
{
  NSLog(@"dismiss");
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    [[coordinator topViewController] dismissViewControllerAnimated:animated completion:nil];
  });
}

RCT_EXPORT_METHOD(pop:(NSDictionary *)payload animated:(BOOL)animated)
{
  NSLog(@"pop");
  // TODO(lmr):
  // if top VC is being presented in a TabBarController, pop will pop all of the
  // Tabs, in which case we should make sure to dereference each of them.

  // TODO(lmr):
  // what if the JS environment wants to pop a parent navigationController of the
  // top navigationController? Perhaps we could pass an optional "level" param or something.
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    [[coordinator topNavigationController] popViewControllerAnimated:animated];
  });
}

RCT_EXPORT_METHOD(replace:(NSString *)screenName withProps:(NSDictionary *)props animated:(BOOL)animated)
{
  NSLog(@"replace: %@", screenName);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    RNNViewController *pushed = [coordinator newViewController:screenName withProps:props];
    [[coordinator topNavigationController] pushViewController:pushed animated:animated];
  });
}

RCT_EXPORT_METHOD(setTabIndex:(NSUInteger)index animated:(BOOL)animated)
{
  // TODO(lmr): animated
  NSLog(@"setTabIndex: %i", index);
  dispatch_async(dispatch_get_main_queue(), ^{
    RNNCoordinator *coordinator = [RNNCoordinator sharedInstance];
    UIViewController *vc = [coordinator topViewController];
    if (vc == nil) {
      NSLog(@"ViewController is null!");
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
      NSLog(@"its a tabbar!");
    }
    UITabBarController *tabBarController = [coordinator topTabBarController];
    if (tabBarController == nil) {
      NSLog(@"Its null!");
    }
    [tabBarController setSelectedIndex:index];
  });
}

@end