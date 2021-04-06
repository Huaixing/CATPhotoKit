//
//  CATViewController.m
//  CATPhotoKit
//
//  Created by Huaixing on 09/01/2020.
//  Copyright (c) 2020 Huaixing. All rights reserved.
//

#import "CATViewController.h"
#import <CATPhotoKit/CATPhotoKit.h>

@interface CATViewController ()<UITextViewDelegate>

/// textview
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybShow) name:UIKeyboardWillShowNotification object:nil];
    
//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
//    _textView.backgroundColor = [UIColor redColor];
//    _textView.font = [UIFont systemFontOfSize:18];
//    _textView.alwaysBounceVertical = YES;
//    _textView.layoutManager.allowsNonContiguousLayout = NO;
//    _textView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
////    _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 100, 0);
//    [self.view addSubview:_textView];
//    _textView.delegate = self;

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
//    pick.pickMode = CATPickModeSinglePick;
    pick.limitPhotoCount = 2;
    pick.autoIntoLibrary = NO;
    pick.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}

//- (voi)

@end
