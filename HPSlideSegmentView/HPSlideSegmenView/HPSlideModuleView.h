//
//  HPSlideView.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/12.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPSegmentEnum.h"
@class HPSlideModuleView;

typedef void (^HPSLIDEMODULBUTTONBLOCK)(id weak,NSUInteger buttonIndex);

@protocol SlideModuleViewDelegate <NSObject>

@optional


/**
 Button内容的设置

 @param index 位置
 @return 显示的内容
 */
-(NSString *)hp_slideContentWithIndex:(NSUInteger)index;


/**
 自定义button

 @param index 位置
 @return 返回设置的button
 */
-(UIButton *)hp_slideWithIndex:(NSUInteger)index;

@end

@interface HPSlideModuleView : UIView

@property(nonatomic,weak) id<SlideModuleViewDelegate> delegate;

@property(nonatomic,assign) BOOL spaceLine;


/**
 当前有多少个数据源
 */
@property(nonatomic,assign) NSUInteger showCount;


/**
 滑块的背景颜色 当slideModuleView为自定义 此属性是无效
 */
@property(nonatomic,strong) UIColor *slideModuleColor;


/**
 滑块view
 */
@property(nonatomic,strong) UIView *slideModuleView;

/**
 滑块的宽度
 */
@property(nonatomic,assign) CGFloat slideModeuleWidth;


/**
 上滑左右的边距
 */
@property(nonatomic,assign) UIEdgeInsets edgeInsets;


/**
 最小大小
 */
@property(nonatomic,assign) CGFloat minWidth;


/**
 Button的变化样式
 */
@property(nonatomic,assign) AutoSizeType type;


/**
 是否需要显示滑块
 */
@property(nonatomic,assign) BOOL hiddenModule;


/**
 button 没有默认的背景颜色
 */
@property(nonatomic,strong) UIColor *backgroundDefaultColor;


/**
 button 选择的背景颜色
 */
@property(nonatomic,strong) UIColor *backgroundSelectColor;


/**
 改变当前module的位置

 @param index 位置
 */
-(void)updateLayoutWithIndex:(NSUInteger)index;


/**
 点击事件

 @param weakObj 需要弱引用对象
 @param actionBlock 事件
 */
-(void)hp_weak:(id)weakObj actionButton:(HPSLIDEMODULBUTTONBLOCK)actionBlock;


/**
 更新
 */
-(void)updateLayout;


/**
 更新滑块的位置

 @param nowIndex 当前的位置
 @param readyIndex 准备到达的位置
 @param movePercent 当前位置到达准备位置的进度
 */
-(void)slideWithNowIndex:(NSUInteger)nowIndex readyIndex:(NSUInteger)readyIndex movePercent:(CGFloat)movePercent;



@end


@interface UIButton (HPSlideSegment)


/**
 button 的index
 */
@property(nonatomic,assign) NSUInteger index;

@end
