//
//  UIImage+Bundle.m
//  CATPhotoKit
//
//  Created by Shihuaixing on 2020/9/8.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (UIImage *)imageWithName:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"CATPhotoKit" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
