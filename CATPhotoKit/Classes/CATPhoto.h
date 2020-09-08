//
//  CATPhoto.h
//  TestOCLint
//
//  Created by Shihuaixing on 2020/8/4.
//  Copyright © 2020 Shihuaixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface CATPhoto : NSObject

/**phasset*/
@property (nonatomic, strong) PHAsset *asset;

/**identifier*/
@property (nonatomic, copy) NSString *localIdentifier;

/**icloud*/
@property (nonatomic, assign, getter = isiCloud) BOOL iCloud;

/**缩略图*/
@property (nonatomic, strong) UIImage *image;

/// selected
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end

