//
//  HPSlideSegmentView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/11.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPSlideSegmentBackgroundView.h"

@interface HPSlideSegmentControllerView : UIViewController


/**
 头部的UIView
 */
@property(nonatomic,strong) UIView *headeView;


/**
 头部的高度 如果不设置默认为 headerView的的高度
 */
@property(nonatomic,assign) CGFloat headeViewHeight;



/**
 距离底部的高
 */
@property(nonatomic,assign) CGFloat bottomSpaceHeight;


/**
 左右滑视图
 */
@property(nonatomic,strong) HPSlideSegmentBackgroundView *slideBackgroungView;

@end