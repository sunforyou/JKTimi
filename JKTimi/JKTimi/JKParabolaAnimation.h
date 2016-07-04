//
//  JKParabolaAnimation.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/21.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKParabolaAnimationDelegate <NSObject>

/**
 *  抛物线动画结束回调
 */
- (void)parabolaAnimationDidFinished;

@end

@interface JKParabolaAnimation : NSObject

@property (nonatomic, assign) id<JKParabolaAnimationDelegate>delegate;

/**
 *  单例
 */
+ (JKParabolaAnimation *)parabolaAnimationSharedInstance;


/**
 *  抛物线动画
 *
 *  @param selectedView     执行动画的控件
 *  @param originalPoint    起点坐标
 *  @param destinationPoint 终点坐标
 *  @param duration         动画时长
 *  @param scale            缩放比例
 */
- (void)pathAnimationQuadCurveForView:(UIImageView *)selectedView
                            fromPoint:(CGPoint)originalPoint
                              toPoint:(CGPoint)destinationPoint
                         withDuration:(CGFloat)duration
                              scaleTo:(float)scale;
@end
