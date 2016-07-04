//
//  UIView+anchorPoint.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/24.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "UIView+anchorPoint.h"

@implementation UIView (anchorPoint)

- (void)setAnchorPointTo:(CGPoint)point{
    self.frame = CGRectOffset(self.frame, (point.x - self.layer.anchorPoint.x) * self.frame.size.width, (point.y - self.layer.anchorPoint.y) * self.frame.size.height);
    self.layer.anchorPoint = point;
}

@end
