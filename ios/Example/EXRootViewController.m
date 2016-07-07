#import "EXRootViewController.h"
#import "RCTBridge.h"
#import "RNNViewController.h"
#import "RNNCoordinator.h"
#import "EXTabBarController.h"
#import "EXNativeViewController.h"

@implementation EXRootViewController {

}

#pragma mark RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  return [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
}

#pragma mark RNNCoordinatorDelegate

- (UIViewController *)rootControllerForCoordinator:(RNNCoordinator *)coordinator {
  return [self navigationController];
}

- (UIViewController *)nativeViewControllerFromName:(NSString *)moduleName withProps:(NSDictionary *)props {
  typedef UIViewController *(^CaseBlock)();

  NSDictionary<NSString *, CaseBlock> *cases = @{
    @"NativeExample": ^{
      return [[EXNativeViewController alloc] initWithNibName:nil bundle:nil];
    },
    @"TabExample": ^{
        EXTabBarController *tc = [[EXTabBarController alloc] init];
        RNNViewController *tab1 = [[RNNCoordinator sharedInstance] newViewController:@"TabOne" withProps:nil];
        tab1.tabBarItem.title = @"TabOne";


        RNNViewController *tab2 = [[RNNCoordinator sharedInstance] newViewController:@"TabTwo" withProps:nil];
        tab2.tabBarItem.title = @"TabTwo";

        [tc setViewControllers:@[ tab1, tab2 ]];
        return tc;
    },
  };

  CaseBlock fn = cases[moduleName];
  return fn != nil ? fn() : nil;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Root Controller";
  self.view.backgroundColor = [UIColor blueColor];

  // add button
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:@"Push ScreenOne" forState:UIControlStateNormal];
  button.frame = CGRectMake(0, 100, 320, 140);
  [button addTarget:self action:@selector(pushScreenOne) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

  UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button2 setTitle:@"Push TabBar" forState:UIControlStateNormal];
  button2.frame = CGRectMake(0, 300, 320, 140);
  [button2 addTarget:self action:@selector(pushTabBar) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button2];
}

#pragma mark Private Methods

- (void)pushScreenOne {
  RNNViewController *rnvc = [[RNNCoordinator sharedInstance] newViewController:@"ScreenOne" withProps:nil];
  [self.navigationController pushViewController:rnvc animated:YES];
}

- (void)pushTabBar {
  EXTabBarController *tc = [[EXTabBarController alloc] init];
  RNNViewController *tab1 = [[RNNCoordinator sharedInstance] newViewController:@"TabOne" withProps:nil];
  tab1.tabBarItem.title = @"TabOne";


  RNNViewController *tab2 = [[RNNCoordinator sharedInstance] newViewController:@"TabTwo" withProps:nil];
  tab2.tabBarItem.title = @"TabTwo";

  [tc setViewControllers:@[ tab1, tab2 ]];
  [self.navigationController pushViewController:tc animated:YES];
}

@end