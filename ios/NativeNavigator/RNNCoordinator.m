#import "RNNCoordinator.h"
#import "RNNViewController.h"
#import "RNNCoordinatorDelegate.h"
#import "RCTBridge.h"


@implementation RNNCoordinator {
  NSMutableDictionary<NSString *, RNNViewController *> *_viewControllers;
  NSMutableDictionary<NSString *, NSString *> *_classMap;
//  NSMutableArray<NSString *> *_idStack;
}

+ (instancetype)sharedInstance {
  static RNNCoordinator *sharedInstance = nil;
  static dispatch_once_t  onceToken;

  dispatch_once(&onceToken, ^{
    sharedInstance = [[RNNCoordinator alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _viewControllers = [[NSMutableDictionary alloc] init];
//    _idStack = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)registerRNViewController:(RNNViewController *)viewController {
//  [_idStack addObject:viewController.viewControllerId];
  _viewControllers[viewController.viewControllerId] = viewController;
}

- (void)unregisterRNViewController:(NSString *)viewControllerId {
  _viewControllers[viewControllerId] = nil;
//  if ([_idStack containsObject:viewControllerId]) {
//    NSUInteger index = [_idStack indexOfObject:viewControllerId];
//    [_idStack removeObjectAtIndex:index];
//  }
}

- (RNNViewController *)viewControllerWithId:(NSString *)id {
  return _viewControllers[id];
}

//- (RNNViewController *)top {
//  if ([_idStack count] == 0) {
//    return nil;
//  }
//  return _viewControllers[[_idStack lastObject]];
//}


- (void)registerViewController:(Class)classObj withName:(NSString *)name {
  _classMap[name] = NSStringFromClass(classObj);
}

- (UIViewController *)viewControllerFromName:(NSString *)name withProps:(NSDictionary *)props {
  NSString *className = _classMap[name];
  Class classObj = NSClassFromString(className);
  UIViewController *vc = [(UIViewController *) [classObj alloc] initWithNibName:nil bundle:nil];
  // TODO(lmr): apply props
  return vc;
}

#pragma mark ViewController Arithmetic

- (UIViewController *)topViewController {
  UIViewController *vc = [self.delegate rootControllerForCoordinator:self];

  while (true) {
    if ([vc isKindOfClass:[UITabBarController class]])
    {
      UITabBarController *tabBarController = (UITabBarController *)vc;
      vc = tabBarController.selectedViewController;
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
      UINavigationController *navigationController = (UINavigationController *)vc;
      vc = navigationController.visibleViewController;
    }
    else if (vc.presentedViewController)
    {
      vc = vc.presentedViewController;
    }
    else if (vc.childViewControllers.count > 0)
    {
      vc = vc.childViewControllers.lastObject;
    } else {
      break;
    }
  }

  return vc;
}

- (UINavigationController *)topNavigationController {
  return [[self topViewController] navigationController];
}

- (UITabBarController *)topTabBarController {
  return [[self topViewController] tabBarController];
}

- (RNNViewController *)newViewController:(NSString *)moduleName withProps:(NSDictionary *)props {
  return [[RNNViewController alloc] initWithBridge:self.bridge
                                         andModule:moduleName
                                          andProps:props];
}

- (UIViewController *)nativeViewControllerFromName:(NSString *)name withProps:(NSDictionary *)props {
  return [self.delegate nativeViewControllerFromName:name withProps:props];
}

@end