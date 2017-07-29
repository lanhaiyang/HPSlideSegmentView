//
//  HPSlideLogic.h
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct{
    
    CGFloat x;
    CGFloat width;
    
}HPPoint;

typedef struct {
    NSInteger number;
    char *error;
}HPNumber;

CG_INLINE HPPoint
HPPointMake(CGFloat x, CGFloat width)
{
    HPPoint point;
    point.x=x;
    point.width=width;
    return point;
}

CG_INLINE HPNumber
HPNumberMake(NSUInteger index, char *string)
{
    HPNumber number;
    number.number=index;
    number.error=string;
    return number;
}

typedef void (^CHANGEINDEXBLOCK)(HPNumber left,HPNumber centre,HPNumber right,CGPoint startPoint);
typedef void (^ENDBLOCK)();

@interface HPSlideSegmentLogic : NSObject


/**
 滑块的布局

 @param oldpoint 前一个滑块的位置
 @param slideViewHeight 当前滑块的高度
 @param text 滑块显示的内容
 @param fontSize 滑块上面label字体的大小
 @param spaceWidth button和button之间的间距
 @return 返回一个 frame
 */
+(CGRect)oldButtonPoint:(HPPoint)oldpoint
        slideViewHeight:(CGFloat)slideViewHeight
                content:(NSString *)text
               fontSize:(CGFloat)fontSize
             spaceWidth:(CGFloat)spaceWidth;


/**
 设置跟踪滑块的高度

 @param slideModuleHeight 滑块的高度
 @param slideViewHeight 滑块的背景view
 @param width 滑块的宽度
 @param buttonX button的X位置
 @return 返回 滑块的frame
 */
+(CGRect)slideModuleWithView:(CGFloat)slideModuleHeight
             slideViewHeight:(CGFloat)slideViewHeight
                defauleWidth:(CGFloat)width
                 buttonWithX:(CGFloat)buttonX;


/**
 判断越界

 @param arrays 数据源
 @param index 当前的index
 @return 返回在合理范围的 arrays 的数据
 */
+(id)arrayCount:(NSArray *)arrays index:(NSInteger)index;


/**
 防止数组越界

 @param arrayCount 数据源 (不能为0)
 @param index 当前的位置
 @return 返回一个合理位置
 */
+(NSUInteger)arraCount:(NSUInteger)arrayCount index:(NSInteger)index;


/**
 设置contentSize.width
 
 @param width scrollView的宽度
 @param dataArrayCount 数据源的个数
 @return 返回contentSize.width
 */
+(CGFloat)scrollViewWidth:(NSUInteger)width dataArrayCount:(NSUInteger)dataArrayCount;

/**
 边界判断

 @param width scrollview的宽度
 @param dataArrayCount 数据源的个数
 @param currentIndex 当前位置
 @return 返回Offset位置
 */
+(CGFloat)scrollViewWidth:(NSUInteger)width
           arrayDataCount:(NSUInteger)dataArrayCount
             currentIndex:(NSUInteger)currentIndex;


/**
 判断方向

 @param scrollView 滑动scrollview
 @param currentIndex 当前位置
 @param startOffset 滑动开始位置
 @param arrayDataCount 数据源的个数 (不能为0)
 @return 返回移动的
 */
+(NSUInteger)scrollView:(UIScrollView *)scrollView
           currentIndex:(NSUInteger *)currentIndex
            startOffset:(CGPoint )startOffset
              dataArray:(NSUInteger )arrayDataCount;


/**
 滑动停止返回的位置信息

 @param slideViewWidth  scrollview的宽度
 @param scrollView      滑动的scrollview
 @param currentIndex    当前的index
 @param startOffset       结束的offset
 @param arrayDataCount  数据源的个数 (不能为0)
 @param changeBlock     返回位置信息
 @param endBlock        当currentIndex设置完成介绍
 */
+(void)slideSuperView:(CGFloat)slideViewWidth
           scrollView:(UIScrollView *)scrollView
         currentIndex:(NSUInteger *)currentIndex
            startOffset:(CGPoint )startOffset
            dataArray:(NSUInteger )arrayDataCount
          changeIndex:(CHANGEINDEXBLOCK)changeBlock
             endIndex:(ENDBLOCK)endBlock;


/**
 滑块动画

 @param slideModule 需要设置滑块动画
 @param slideModuleWith 滑块的实际宽度
 @param nowPoint  当前位置
 @param readyPoint 准备到达的位置
 @param movePercent 从当前位置到准备位置的百分比
 */
+(void)animationSlideView:(UIView *)slideModule
         slideModuleWidht:(CGFloat)slideModuleWith
                 nowPoint:(HPPoint)nowPoint
              readyButton:(HPPoint)readyPoint
              movePercent:(CGFloat)movePercent;


/**
 跳转到指定页面

 @param currentIndex 指定页面的index
 @param arrayCount 数据源的个数
 @param scrollView 滑动的scrollView
 @param slideViewWidth scrollview的宽度
 @param changeBlock 返回位置信息
 */
+(void)currentIndex:(NSUInteger)currentIndex
         arrayCount:(NSUInteger)arrayCount
         scrollView:(UIScrollView *)scrollView
     slideSuperView:(CGFloat)slideViewWidth
        changeIndex:(CHANGEINDEXBLOCK)changeBlock;


/**
 滑块居中逻辑

 @param currentScrollerView 当前的scrollview
 @param slideModuleX 滑块的X位置
 */
+(void)slideModuleAlignCenter:(UIScrollView *)currentScrollerView
             slideModuleWithX:(CGFloat)slideModuleX;


@end
