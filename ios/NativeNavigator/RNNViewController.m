#import "RNNViewController.h"
#import "RCTBridge.h"
#import "RCTRootView.h"
#import "RNNCoordinator.h"

static int _uuid = 1;

@implementation RNNViewController {

}

- (instancetype)initWithBridge:(RCTBridge *)bridge
                     andModule:(NSString *)moduleName
                      andProps:(NSDictionary *)props {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _statusBarStyle = UIStatusBarStyleDefault;
    _statusBarUpdateAnimation = UIStatusBarAnimationFade;
    _statusBarHidden = NO;

    _viewControllerId = [NSString stringWithFormat:@"%@_%i", moduleName, _uuid++];

    NSLog(@"Initialized View Controller: %@", _viewControllerId);
    self.bridge = bridge;
    self.moduleName = moduleName;
    self.props = [self amendProps:props];
  }
  return self;
}

- (NSDictionary *)amendProps:(NSDictionary *)passedProps {
  NSMutableDictionary *ret;
  if (passedProps == nil) {
    ret = [@{} mutableCopy];
  } else {
    ret = [passedProps mutableCopy];
  }
  ret[@"viewControllerId"] = _viewControllerId;
  return ret;
}

#pragma mark Event Handlers

- (void)barButtonItemPressed {
  [self emitEvent:@"onRightPress" withBody:nil];
}

- (void)emitEvent:(NSString *)eventName withBody:(id)body {
  NSString *name = [NSString stringWithFormat:@"NNNavigatorScene.%@.%@", eventName, self.viewControllerId];
  [self.bridge enqueueJSCall:@"RCTDeviceEventEmitter.emit"
                        args:body ? @[name, body] : @[name]];
}

#pragma mark ViewController Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                           moduleName:self.moduleName
                                    initialProperties:self.props];
  [self.view addSubview:self.rootView];
  [self.rootView setFrame:self.view.bounds];

  // TODO(lmr):
  [[RNNCoordinator sharedInstance] registerRNViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self emitEvent:@"onAppear" withBody:nil];
//  NSLog(@"viewDidAppear: %@", _viewControllerId);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self emitEvent:@"onDisappear" withBody:nil];
//  NSLog(@"viewWillDisappear: %@", _viewControllerId);

  if (self.tabBarController != nil) {
    if ([self.tabBarController.viewControllers containsObject:self]) {
      // return early because we don't want to unregister this... should
      // probably figure out a better way to do this at some point.
      return;
    }
  }

  if ([[self.navigationController viewControllers] containsObject:self])
  {
    // some new view controller is being pushed over us
  } else {
    // We are being popped off of the nav stack
//    NSLog(@"POPPED! viewWillDisappear: %@", _viewControllerId);

    [[RNNCoordinator sharedInstance] unregisterRNViewController:self.viewControllerId];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
//  NSLog(@"viewDidDisappear: %@", _viewControllerId);

  if ([[self.navigationController viewControllers] containsObject:self])
  {
    // some new view controller is being pushed over us
  } else {
    // We are being popped off of the nav stack
//    NSLog(@"POPPED! viewDidDisappear: %@", _viewControllerId);
  }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
  [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  [super didMoveToParentViewController:parent];
  NSLog(@"didMoveToParentViewController: %@", _viewControllerId);
  if (parent == nil) {
    // we must have been popped from the navigation stack
  }
}



#pragma mark StatusBar Style

- (void)updateStatusBar:(BOOL)animated {
  NSTimeInterval duration = animated ? 0.2 : 0;
  [UIView animateWithDuration:duration animations:^{
      [self setNeedsStatusBarAppearanceUpdate];
  }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return _statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
  return _statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return _statusBarUpdateAnimation;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style {
  _statusBarStyle = style;
  [self updateStatusBar:NO];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animated {
  _statusBarStyle = style;
  [self updateStatusBar:animated];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
  _statusBarHidden = statusBarHidden;
  [self updateStatusBar:NO];
}

- (void)setStatusBarHidden:(BOOL)hidden animation:(UIStatusBarAnimation)animation {
  _statusBarHidden = hidden;
  _statusBarUpdateAnimation = animation;
  [self updateStatusBar:animation != UIStatusBarAnimationNone];
}

- (void)setStatusBarUpdateAnimation:(UIStatusBarAnimation)statusBarUpdateAnimation {
  _statusBarUpdateAnimation = statusBarUpdateAnimation;
  [self updateStatusBar:NO];
}

- (void)dealloc {
  // TODO(lmr): i don't think this is actually doing anything until we make the coordinator
  // use weak references.
  [[RNNCoordinator sharedInstance] unregisterRNViewController:self.viewControllerId];
}

@end