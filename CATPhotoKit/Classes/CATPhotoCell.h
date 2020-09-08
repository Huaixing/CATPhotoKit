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
- (void)photoCell:(CATPhotoCell *)photoCell didSelectedPhoto:(CATPhoto *)photo;

@end

@interface CATPhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<CATPhotoCellDelegate> delegate;
/**photo*/
@property (nonatomic, strong) CATPhoto *photo;

@end


