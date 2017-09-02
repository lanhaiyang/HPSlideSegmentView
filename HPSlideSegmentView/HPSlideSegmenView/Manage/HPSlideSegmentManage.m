//
//  HPSlideManage.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentManage.h"
#import "UIView+HPSlideSegmentRect.h"

@interface HPSlideSegmentManage ()

@property(nonatomic,assign) CGFloat lastPoint;

@end

@implementation HPSlideSegmentManage

static HPSlideSegmentManage *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedSlideManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(void)slideUpSegmentWithMainScrollerView:(UIScrollView *)mainScrollerView
                         showScrollerView:(UIScrollView *)centreScrollerView
                                 upHeight:(CGFloat)topHeight
                                 delegate:(id<HPSlideSegmentManageDelegate>) delegate;
{

    
    mainScrollerView.bounces=NO;
    CGFloat centreY=centreScrollerView.contentOffset.y;
    CGFloat mainY=mainScrollerView.contentOffset.y;
    CGFloat bottomHeight=mainScrollerView.contentSize.height-mainScrollerView.bounds.size.height;
    
    if (centreScrollerView.contentOffset.y==0 || delegate==nil) {
        if ([delegate respondsToSelector:@selector(hp_slideUpSegmentWithMain:)]) {
            
            [delegate hp_slideUpSegmentWithMain:YES];
            
        }
        return;
    }
    
    if (mainY<bottomHeight) {
        
        mainScrollerView.bounces=YES;
        centreScrollerView.contentOffset=CGPointMake(0, 0);
        
        
        if ([delegate respondsToSelector:@selector(hp_slideUpSegmentWithMain:)]) {
            
            [delegate hp_slideUpSegmentWithMain:YES];
            
        }
        
    }
    else
    {
        if ([delegate respondsToSelector:@selector(hp_slideUpSegmentWithMain:)]) {
            
            [delegate hp_slideUpSegmentWithMain:NO];
            
        }
        
        if (centreY-_lastPoint>20) {
            //up
            _lastPoint=centreY;
            
            
            if(centreY>0)
            {
                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight);
            }
            else
            {
                if ([delegate respondsToSelector:@selector(hp_slideUpSegmentWithMain:)]) {
                    
                    [delegate hp_slideUpSegmentWithMain:YES];
                    
                }
            }
        }
        else if (_lastPoint-centreY>20)
        {
            //down
            _lastPoint=centreY;
            
            
        }
        else
        {
            
            if (centreY<=0) {
                
                centreScrollerView.contentOffset=CGPointMake(0, 0);
                if ([delegate respondsToSelector:@selector(hp_slideUpSegmentWithMain:)]) {
                    
                    [delegate hp_slideUpSegmentWithMain:YES];
                    
                }
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
