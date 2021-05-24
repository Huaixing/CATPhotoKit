//
//  CATPhotoBarButton.h
//  CATPhotoKit
//
//  Created by huaixing Shi on 2021/5/13.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CATPhotoBarButtonType) {
    CATPhotoBarButtonNone,      /// 无
    CATPhotoBarButtonBack,      /// 返回<
    CATPhotoBarButtonCancel,    /// 取消
};

@interface CATPhotoBarButton : UIButton

+ (instancetype)barButtonWithBarButtonType:(CATPhotoBarButtonType)barButtonType target:(id)target action:(SEL)action;

@end

