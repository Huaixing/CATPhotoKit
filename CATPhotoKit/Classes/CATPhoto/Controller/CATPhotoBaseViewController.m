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
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF2F2F2"];
    
    CGFloat barHeight = self.navigationController.navigationBar.height;
    if (barHeight <= 0) {
        barHeight = 44;
    }
    CGFloat naviBarHeight = [UIView statusBarHeight] + barHeight;
    _navigationBar = [[CATPhotoNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), naviBarHeight)];
    [self.view addSubview:_navigationBar];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 意图将导航栏置于所有子视图顶部
    [self.view bringSubviewToFront:_navigationBar];
}

- (CGRect)viewFrame {
    return CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.height);
}


@end
