//
//  UIView+Draw.m
//  HHAlertView
//
//  Created by ChenHao on 6/17/15.
//  Copyright (c) 2015 AEXAIR. All rights reserved.
//

#import "UIView+Draw.h"

@implementation UIView (Draw)


- (void)hh_drawCustomeView:(UIView *)customView
{
    [self cleanLayer:self];
    customView.frame = self.frame;
    [self addSubview:customView];
}

- (void)cleanLayer:(UIView *)view
{
    for (CALayer *layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}
@end
