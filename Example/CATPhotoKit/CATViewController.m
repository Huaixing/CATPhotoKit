//
//  CATViewController.m
//  CATPhotoKit
//
//  Created by Huaixing on 09/01/2020.
//  Copyright (c) 2020 Huaixing. All rights reserved.
//

#import "CATViewController.h"
#import <CATPhotoKit/CATPhotoKit.h>

@interface CATViewController ()



@end

@implementation CATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *pickButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [pickButton setTitle:@"Pick" forState:UIControlStateNormal];
    [pickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pickButton.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:pickButton];
    [pickButton addTarget:self action:@selector(pickButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pickButtonDidClick {
    
    CATAlbumViewController *album = [[CATAlbumViewController alloc] init];
    
    CATPhotoPickerController *pick = [[CATPhotoPickerController alloc] initWithRootViewController:album];
    pick.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pick animated:YES completion:nil];
}

@end
