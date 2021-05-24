//
//  CATPhotoBaseViewController.m
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import "CATPhotoBaseViewController.h"

#import <CATCommonKit.h>

@interface CATPhotoBaseViewController ()

@end

@implementation CATPhotoBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    
    CGFloat naviBarHeight = [UIView statusBarHeight] + self.navigationController.navigationBar.height;
    _navigationBar = [[CATPhotoNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), naviBarHeight)];
    _navigationBar.bottom = self.navigationController.navigationBar.height;
    [self.navigationController.navigationBar addSubview:_navigationBar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
