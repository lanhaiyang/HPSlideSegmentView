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
{
//    CGFloat centreY=centreScrollerView.contentOffset.y;
//    CGFloat mainY=mainScrollerView.contentOffset.y;
//
//    
//    if (centreScrollerView.contentOffset.y==0) {
//        return;
//    }
//    
//    if (mainY<topHeight) {
//        mainScrollerView.bounces=YES;
//        centreScrollerView.contentOffset=CGPointMake(0, 0);
//    }
//    else
//    {
//        CGFloat bottomMain=mainScrollerView.contentSize.height-mainY;
//        CGFloat bottomHeight=mainScrollerView.contentSize.height-mainScrollerView.bounds.size.height;
//        CGFloat close=mainY+mainScrollerView.bounds.size.height-mainScrollerView.contentSize.height;
//
//        if (close<0) {
//            close=0;
//        }
//        
//        
//        if (bottomMain<=mainScrollerView.bounds.size.height) {
//            
//            if (centreY<=0) {
//                mainScrollerView.bounces=NO;
//              centreScrollerView.contentOffset=CGPointMake(0, 0);
//            }
//            else
//            {
//                mainScrollerView.bounces=NO;
//                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight-close);
//            }
//        }
//        else
//        {
//            if (centreY>bottomHeight) {
//                mainScrollerView.bounces=NO;
//                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight-close);
//            }
//            else
//            {
//                mainScrollerView.bounces=NO;
//                centreScrollerView.contentOffset=CGPointMake(0, 0);
//            }
//        }
//    }
    
    mainScrollerView.bounces=NO;
    CGFloat centreY=centreScrollerView.contentOffset.y;
    CGFloat mainY=mainScrollerView.contentOffset.y;
    CGFloat bottomHeight=mainScrollerView.contentSize.height-mainScrollerView.bounds.size.height;
    
    if (centreScrollerView.contentOffset.y==0) {
        return;
    }
    
    if (mainY<=topHeight) {
        mainScrollerView.bounces=YES;
        centreScrollerView.contentOffset=CGPointMake(0, 0);
       
        
    }
    else
    {
        
        if (centreY-_lastPoint>=0) {
            //up
            _lastPoint=centreY;
            
            
            if (centreY<=0) {
                
                centreScrollerView.contentOffset=CGPointMake(0, 0);
                
            }
            else if(centreY>0)
            {
                mainScrollerView.contentOffset=CGPointMake(0, bottomHeight);
            }
        }
        else if (_lastPoint-centreY>=0)
        {
            //down
            _lastPoint=centreY;

            
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
