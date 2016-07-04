//
//  JKParabolaAnimation.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/21.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKParabolaAnimation.h"

static JKParabolaAnimation *parabolaAnimation_sharedInstance = nil;

@implementation JKParabolaAnimation

+ (JKParabolaAnimation *)parabolaAnimationSharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parabolaAnimation_sharedInstance = [[self alloc] init];
    });
    return parabolaAnimation_sharedInstance;
}

/**
 *  抛物线动画
 *
 *  @param destinationPoint 终点坐标
 *  @param duration         动画时长
 *  @param scale            控件缩放比例
 *
 *  @return CAAniamtion
 */
- (void)pathAnimationQuadCurveForView:(UIImageView *)selectedView
                            fromPoint:(CGPoint)originalPoint
                              toPoint:(CGPoint)destinationPoint
                         withDuration:(CGFloat)duration
                              scaleTo:(float)scale {
    //初始化抛物线path
    CGPoint start = originalPoint;
    CGPoint focus = CGPointZero;
    CGPoint end = destinationPoint;
    //跳起的高度
    focus.x = start.x + (end.x - start.x) / 2;
    focus.y = start.y - (end.y - start.y);
    
    //绘制抛物线路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, focus.x, focus.y, end.x, end.y);
    
    //抛物线关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath: path];
    CFRelease(path);
    
    //控件缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = [NSNumber numberWithFloat:scale];
    
    //添加组合动画到所给视图层
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.repeatCount = 1;
    [groupAnimation setDuration:duration];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.animations = @[scaleAnimation, animation];
    [selectedView.layer addAnimation:groupAnimation forKey:@"position scale"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(parabolaAnimationDidFinished)]) {
        [self.delegate performSelector:@selector(parabolaAnimationDidFinished) withObject:nil];
    }
}

@end
