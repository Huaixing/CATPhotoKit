//
//  CATPhotoPickerController.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/6.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATPhotoPickerController.h"
#import "CATPhotoViewController.h"

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

#pragma mark - Public
- (void)photoViewControllerDidFinishPickPhotos:(NSArray<CATPhoto *> *)photos {
    
}


@end
