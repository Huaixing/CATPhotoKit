//
//  CATPhotoPickerController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/6.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATPhotoPickerController.h"

@interface CATPhotoPickerController ()

@end

@implementation CATPhotoPickerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _columns = 4;
        _space = 1.0;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _columns = 4;
        _space = 1.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based appliCATion, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
