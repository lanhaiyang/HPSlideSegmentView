//
//  HPSlideSegmentView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/12.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPSlideModel;

@protocol HPSlideSegmentViewDataSouce <NSObject>


/**
 设置滑动内容

 @param slideSegmentView 传入对应的ViewController 和 ViewController上面继承scrollview的对象
 @param index 对应的index
 */
-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index;

@end

@protocol HPSlideSegmentViewDelegate <NSObject>


/**
 监听当前和准备到达的index

 @param nowIndex 当前的index
 @param readyIndex 准备到达的index
 @param movePercent nowIndex到达readyIndex 的进度
 */
-(void)hp_slideWithNowIndex:(NSUInteger)nowIndex readyIndex:(NSUInteger)readyIndex movePercent:(CGFloat)movePercent;

@end

@protocol HPSlideUpViewDelegate <NSObject>


/**
 返回当前的ScrollView

 @param mainSlideScrollView 当前的scrollView
 */
-(void)hp_currentMainSlideScrollView:(UIScrollView *)mainSlideScrollView;

@end

@interface HPSlideSegmentView : UIView

@property(nonatomic,weak) id<HPSlideSegmentViewDataSouce> dataSource;
@property(nonatomic,weak) id<HPSlideSegmentViewDelegate> delegate;
@property(nonatomic,weak) id<HPSlideUpViewDelegate> upDelegate;


/**
 更新布局
 */
-(void)updateLayout;


/**
 更新布局

 @param arrayCount 当前数据源的个数
 */
-(void)updateScrollerViewWidthWidth:(NSUInteger)arrayCount;


/**
 更新 对应的index

 @param pageIndex 对应的index
 */
-(void)updateLayout:(NSUInteger)pageIndex;

@end

@interface HPSlideModel : UIView


/**
 显示的ViewController
 */
@property(nonatomic,strong) UIViewController *showViewController;


/**
 ViewController 上面 的scrollView
 */
@property(nonatomic,strong) UIScrollView *mainSlideScrollView;

@end
