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
        [self setupInitial];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setupInitial];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private

- (void)setupInitial {
    _columns = 4;
    _space = 1.0;
    _limitPhotoCount = 9;
    _pickMode = CATPickModeMultiplePick;
    _autoIntoLibrary = YES;
}

- (void)photoViewControllerDidFinishPickPhotos:(NSArray<CATPhoto *> *)photos {
    if (self.picker && [self.picker respondsToSelector:@selector(photoPickerController:didFinishPickPhotos:)]) {
        [self.picker photoPickerController:self didFinishPickPhotos:photos];
    }
}

#pragma mark - Public
- (void)setLimitPhotoCount:(NSUInteger)limitPhotoCount {
    if (limitPhotoCount == 1) {
        _pickMode = CATPickModeSinglePick;
    }
    _limitPhotoCount = limitPhotoCount;
}

- (void)setPickMode:(CATPickMode)pickMode {
    if (_limitPhotoCount == 1) {
        _pickMode = CATPickModeSinglePick;
    } else {
        _pickMode = pickMode;
    }
}


@end
