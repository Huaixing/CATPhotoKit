//
//  CATPhotoCell.m
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import "CATPhotoCell.h"
#import "CATLibrary.h"
#import "CATPhoto.h"

@interface CATPhotoCell ()<CATPhotoDownLoadDelegate>
/**imageview*/
@property (nonatomic, strong) UIImageView *photoView;
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
    }
    return self;
}


- (void)setPhoto:(CATPhoto *)photo {
    _photo = photo;
    
    _photoView.image = nil;
    if (_photo.image) {
        _photoView.image = _photo.image;
    } else {
        [[CATPhotoManager shareManager] requestAssetImageWithPhoto:photo targetSize:_photoView.frame.size delegate:self];
    }
}

#pragma mark - CATPhotoDownLoadDelegate
- (void)photoManagerDownLoadSuccess:(CATPhotoManager *)manager result:(UIImage *)result identifier:(NSString *)identifier {
    if (identifier && result && [self.photo.localIdentifier isEqualToString:identifier]) {
        self.photoView.image = result;
        self.photo.image = result;
    }
}

@end
