//
//  CATPhotoNavigationBar.h
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import <UIKit/UIKit.h>
#import "CATPhotoBarButton.h"


@interface CATPhotoNavigationBar : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *barColor;

@property (nonatomic, strong) CATPhotoBarButton *leftBarButton;

@property (nonatomic, strong) CATPhotoBarButton *rightBarButton;

@end

