//
//  CATPhotoCell.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/5.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATPhoto;

@interface CATPhotoCell : UICollectionViewCell
/***/
//@property (nonatomic, assign) NSUInteger index;
/**photo*/
@property (nonatomic, strong) CATPhoto *photo;

@end


