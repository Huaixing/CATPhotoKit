//
//  CATPhotoCell.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATPhoto, CATPhotoCell;

@protocol CATPhotoCellDelegate <NSObject>

@optional

/// 勾选或取消勾选Asset
/// @param photoCell self
/// @param photo photo
- (void)photoCell:(CATPhotoCell *)photoCell didSelectedPhoto:(CATPhoto *)photo;

/// 能否继续选中Asset
/// @param photoCell self
/// @param photo photo
- (BOOL)photoCell:(CATPhotoCell *)photoCell shouldSelectedPhoto:(CATPhoto *)photo;

@end

@interface CATPhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<CATPhotoCellDelegate> delegate;
/**photo*/
@property (nonatomic, strong) CATPhoto *photo;
/// 是否支持多选（多选只针对照片）
@property (nonatomic, assign) BOOL canMultiplePick;

@end


