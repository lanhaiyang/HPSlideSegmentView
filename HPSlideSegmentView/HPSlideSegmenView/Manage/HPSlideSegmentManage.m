//
//  HPSlideManage.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentManage.h"

@implementation HPSlideSegmentManage



+(void)slideUpSegmentWithMainScrollerView:(UIScrollView *)mainScrollerView
                         showScrollerView:(UIScrollView *)centreScrollerView
                                 upHeight:(CGFloat)topHeight
{
    CGFloat centreY=centreScrollerView.contentOffset.y;
    CGFloat mainY=mainScrollerView.contentOffset.y;

    
    if (centreScrollerView.contentOffset.y==0) {
        return;
    }
    
    if (mainY<topHeight) {
        mainScrollerView.bounces=YES;
        centreScrollerView.contentOffset=CGPointMake(0, 0);
    }
    else
    {
        CGFloat bottomMain=mainScrollerView.contentSize.height-mainY;
        CGFloat bottomHeight=mainScrollerView.contentSize.height-mainScrollerView.bounds.size.height;
        CGFloat close=mainY+mainScrollerView.bounds.size.height-mainScrollerView.contentSize.height;

        if (close<0) {
            close=0;
        }
        
        
        if (bottomMain<=mainScrollerView.bounds.size.height) {
            
            if (centreY<=0) {
                mainScrollerView.bounces=YES;
              centreScrollerView.contentOffset=CGPointMake(0, 0);
            }
            else
            {
                mainScrollerView.bounces=NO;
                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight-close);
            }
        }
        else
        {
            if (centreY>bottomHeight) {
                mainScrollerView.bounces=NO;
                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight-close);
            }
            else
            {
                mainScrollerView.bounces=YES;
                centreScrollerView.contentOffset=CGPointMake(0, 0);
            }
        }
    }
    
    
}

+(void)slidetLogicSrollerView:(UIScrollView *)mainScrollerView
                         showScrollerView:(UIScrollView *)centreScrollerView
                                 upHeight:(CGFloat)topHeight
                      slideUpSegmentBlock:(SlideUpSegmentBlock)upBlock
{

    
    
    
    CGFloat offsetHeight=mainScrollerView.contentOffset.y-topHeight;
    CGPoint topPoint=CGPointMake(0, 0);

    if (offsetHeight<0) {
        topPoint=CGPointMake(0, 0);
    }
    else if (offsetHeight==0)
    {
        topPoint=CGPointMake(0, 0);
    }
    else if (offsetHeight>0)
    {
        CGFloat scrollSizeHeight=mainScrollerView.contentSize.height-mainScrollerView.contentOffset.y;
        
        if (scrollSizeHeight<=mainScrollerView.bounds.size.height)
        {
            topPoint=CGPointMake(0, offsetHeight);
        }
        else
        {
            topPoint=CGPointMake(0, offsetHeight);
        }
        
    }

    
    if (upBlock!=nil) {
        upBlock(topPoint);
    }
    
}

@end
