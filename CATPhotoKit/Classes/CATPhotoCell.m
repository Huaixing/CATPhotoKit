//
//  CATPhotoCell.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//
#import <CATCommonKit/CATCommonKit.h>
#import "CATPhotoCell.h"
#import "CATLibrary.h"
#import "CATPhoto.h"
#import "UIImage+Bundle.h"

@interface CATPhotoCell ()<CATPhotoDownLoadDelegate>
/**imageview*/
@property (nonatomic, strong) UIImageView *photoView;

/// check button
@property (nonatomic, strong) UIButton *checkButton;
/// check icon
@property (nonatomic, strong) UIImageView *checkView;
@end

@implementation CATPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _photoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoView.backgroundColor = [UIColor clearColor];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self.contentView addSubview:_photoView];
        
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width / 2.0, self.height / 2.0, self.width / 2.0, self.height / 2.0)];
        _checkButton.backgroundColor = [UIColor clearColor];
        [_checkButton addTarget:self action:@selector(checkButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkButton];
        
        UIImage *image = [UIImage imageWithName:@"cat_photo_thumb_unselected_icon"];
        _checkView = [[UIImageView alloc] initWithImage:image];
        _checkView.backgroundColor = [UIColor clearColor];
        [_checkButton addSubview:_checkView];
    }
    return self;
}

#pragma mark - Public
- (void)setPhoto:(CATPhoto *)photo {
    _photo = photo;
    
    _photoView.image = nil;
    if (_photo.image) {
        _photoView.image = _photo.image;
    } else {
        [[CATPhotoManager shareManager] requestAssetImageWithPhoto:photo targetSize:_photoView.frame.size delegate:self];
    }
    // 更新照片选中状态
    [self updatePhotoSelectedStatus];
}

#pragma mark - Private

/// 更新照片的选中状态
- (void)updatePhotoSelectedStatus {
    if (_photo.isSelected) {
        UIImage *selectedImage = [UIImage imageWithName:@"cat_photo_thumb_selected_icon"];
        _checkView.image = selectedImage;
    } else {
        UIImage *defaultImage = [UIImage imageWithName:@"cat_photo_thumb_unselected_icon"];
        _checkView.image = defaultImage;
    }
}

#pragma mark - CATPhotoDownLoadDelegate
- (void)photoManagerDownLoadSuccess:(CATPhotoManager *)manager result:(UIImage *)result identifier:(NSString *)identifier {
    if (identifier && result && [self.photo.localIdentifier isEqualToString:identifier]) {
        self.photoView.image = result;
        self.photo.image = result;
    }
}

#pragma mark - Action
- (void)checkButtonDidClick {
    _photo.selected = !_photo.isSelected;
    // 更新照片选中状态
    [self updatePhotoSelectedStatus];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCell:didSelectedPhoto:)]) {
        [self.delegate photoCell:self didSelectedPhoto:_photo];
    }
}

@end
