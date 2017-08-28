//
//  HPSlideLogic.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentLogic.h"
#import "UIView+HPSlideSegmentRect.h"

@implementation HPSlideSegmentLogic

+(CGRect)oldButtonPoint:(HPPoint)oldpoint
        slideViewHeight:(CGFloat)slideViewHeight
               isModule:(BOOL)isModule
                content:(NSString *)text
               fontSize:(CGFloat)fontSize
             edgeInsets:(UIEdgeInsets)edgeInsets
               minWidth:(CGFloat)minWidth
               autoType:(AutoSizeType)type;
{
    CGFloat x=oldpoint.x+oldpoint.width;
    CGFloat y=0;
    CGFloat width=[self widthForText:slideViewHeight content:text fontSize:fontSize];
    CGFloat height=slideViewHeight-(isModule==NO?3:0);
    
    if (oldpoint.width!=0) {
        x=x+edgeInsets.left+edgeInsets.right;
    }
    else
    {
        x=x+edgeInsets.left;
    }
    y=y+edgeInsets.top;
    height=height-edgeInsets.bottom-edgeInsets.top;
    
    switch (type) {
        case ENUM_HP_AUTOSIZE:
        {
            
        }
            break;
        case ENUM_HP_DEFINESIZE:
        {
            width=minWidth;
        }
            break;
        case ENUM_HP_AUTOMINSIZE:
        {
            width=width>minWidth?width:minWidth;

        }
            break;
        default:
            break;
    }
    
    return CGRectMake(x, y, width, height);
}



+(id)arrayCount:(NSArray *)arrays index:(NSInteger)index
{
    if (arrays.count==0) {
        return nil;
    }
    else if (index<0)
    {
        return arrays[0];
    }
    
    NSUInteger indexType=index;
    
    if (indexType>arrays.count-1) {
        return arrays[arrays.count-1];
    }
    
    return arrays[index];
}

+(id)isArrayWithNil:(NSArray *)arrays index:(NSInteger)index
{
    if (arrays.count==0) {
        return nil;
    }
    else if (index>arrays.count-1) {
        return nil;
    }
    
    return arrays[index];
}

//单独计算文本的高度
+ (CGFloat)widthForText:(CGFloat )height content:(NSString *)text fontSize:(CGFloat)fontSize
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.width;
}

+(CGRect)slideModuleWithView:(CGFloat)slideModuleHeight
             slideViewHeight:(CGFloat)slideViewHeight
                defauleWidth:(CGFloat)width
                 buttonWithX:(CGFloat)buttonX
{
    
    CGFloat y=slideViewHeight-slideModuleHeight;
    CGFloat x=buttonX+((width/2)-width/2);
    if (y<0) {
        return CGRectMake(x, 0, width, slideViewHeight);
    }
    
    return CGRectMake(x, y, width, slideModuleHeight);
    
}

+(NSUInteger)arraCount:(NSUInteger)arrayCount index:(NSInteger)index
{
    if (index<0) {
        return 0;
    }
    
    if (index>arrayCount-1) {
        return arrayCount-1;
    }
    
    return index;
}

+(CGFloat)scrollViewWidth:(NSUInteger)width dataArrayCount:(NSUInteger)dataArrayCount
{

    if (dataArrayCount==1 || dataArrayCount==0) {
        return width;
    }
    else if(dataArrayCount==2)
    {
        return width * 2;
    }
    
    return width * 3;
}

+(CGFloat)scrollViewWidth:(NSUInteger)width
           arrayDataCount:(NSUInteger)dataArrayCount
               currentIndex:(NSUInteger)currentIndex
{
    if (currentIndex==0) {
        return 0;
    }
    else if (currentIndex==dataArrayCount-1)
    {
        return width*(dataArrayCount-1);
    }
    
    return currentIndex * width;
}

+(void)slideSuperView:(CGFloat)slideViewWidth
           scrollView:(UIScrollView *)scrollView
         currentIndex:(NSUInteger *)currentIndex
          startOffset:(CGPoint )startOffset
            dataArray:(NSUInteger )arrayDataCount
          changeIndex:(CHANGEINDEXBLOCK)changeBlock
             endIndex:(ENDBLOCK)endBlock
{
    NSUInteger currentNumber=*currentIndex;

    
    if (arrayDataCount<3) {
        
        *currentIndex=currentNumber;
        
        if (endBlock!=nil) {
            endBlock();
        }
        
        return;
    }
    if (changeBlock==nil) {
        return;
    }

    
    
    [self currentIndex:currentNumber
            arrayCount:arrayDataCount
            scrollView:scrollView
        slideSuperView:slideViewWidth
           changeIndex:changeBlock];
    
    if (endBlock!=nil) {
        endBlock();
    }
    
}

+(void)scrollViewWithStartPoint:(CGPoint)startOffset
                     moveOffset:(CGPoint)moveOffset
               slideModuleWidht:(CGFloat)slideModuleWith
                   currentIndex:(NSUInteger )currentIndex
                      dataArray:(NSUInteger)arrayCount
                startPointBlock:(ChangeStartPoint)startPointBlock
{
    
    CGPoint hp_startOffset=startOffset;
    CGPoint hp_endOffset=CGPointMake(0, 0);
    
    CGFloat changeOffset=startOffset.x-moveOffset.x;
    
    if (changeOffset>0 || (changeOffset==0 && moveOffset.x==0)) {
        if (currentIndex==currentIndex-1 && arrayCount>=3) {
            
            hp_startOffset=CGPointMake(2*slideModuleWith, moveOffset.y);
            hp_endOffset=CGPointMake(slideModuleWith, moveOffset.y);
            
            
        }
        else
        {
            hp_startOffset=CGPointMake(slideModuleWith, moveOffset.y);
            hp_endOffset=CGPointMake(0, moveOffset.y);
        }
        
        
    }
    else if (changeOffset<0 || (changeOffset==0 && moveOffset.x==2*slideModuleWith))
    {
        if(currentIndex == 0)
        {
            hp_startOffset=CGPointMake(0, moveOffset.y);
            hp_endOffset=CGPointMake(slideModuleWith, moveOffset.y);
        }
        else
        {
            hp_startOffset=CGPointMake(slideModuleWith, moveOffset.y);
            
            hp_endOffset=CGPointMake(2*slideModuleWith, moveOffset.y);
        }
        
    }
    
    if (startPointBlock!=nil) {
        
        startPointBlock(hp_startOffset,hp_endOffset);
        
    }
    
}

+(void)scrollView:(UIScrollView *)scrollView
           currentIndex:(NSUInteger *)currentIndex
            startOffset:(CGPoint )startOffset
              endOffset:(CGPoint)endOffset
              dataArray:(NSUInteger )arrayDataCount
        startPointBlock:(ChangeStartPoint)startPointBlock
             boardBlock:(BoardBlock)boardBlock
            moduleBlock:(ModuleAnimationBlock)moduleAnimationBlock
{
    CGPoint off=[scrollView contentOffset];
    CGPoint changeStart=startOffset;
    CGPoint endPoint=endOffset;
    CGFloat changeOffset=startOffset.x-off.x;

    if (changeOffset>0) {

        if (scrollView.contentOffset.x<=startOffset.x && scrollView.contentOffset.x<=endOffset.x) {

            if (*currentIndex==0)
            {
                *currentIndex=*currentIndex;
            }
            else
            {
                *currentIndex=*currentIndex-1;
            }
            
            
            if (*currentIndex==arrayDataCount-1) {
                
                changeStart=CGPointMake(2*scrollView.width, scrollView.contentOffset.y);
                endPoint=CGPointMake(scrollView.width, scrollView.contentOffset.y);
                
            }
            else
            {
                changeStart=CGPointMake(scrollView.width, scrollView.contentOffset.y);
                endPoint=CGPointMake(0, scrollView.contentOffset.y);
            }
            
            
            if (startPointBlock!=nil) {
                
                startPointBlock(changeStart,endPoint);
            }
            
            

            
            if (boardBlock!=nil) {
                boardBlock();
            }

            
        }
        else if (moduleAnimationBlock!=nil) {
            CGFloat percent=fabs(off.x-changeStart.x)/fabs(endPoint.x-changeStart.x);
            NSUInteger exchangeIndex=[self arraCount:arrayDataCount index:*currentIndex-1];
            
            if (exchangeIndex==*currentIndex) {
                return;
            }
            
            moduleAnimationBlock(*currentIndex,exchangeIndex,percent);
        }

        
    }
    else if (changeOffset<0)
    {
        
        if (scrollView.contentOffset.x>=startOffset.x && scrollView.contentOffset.x>=endPoint.x) {
            

            
            if (*currentIndex==arrayDataCount-1)
            {
                *currentIndex=*currentIndex;
            }
            else
            {
                *currentIndex=*currentIndex+1;
            }
            
            if(*currentIndex == 0)
            {
                changeStart=CGPointMake(0, scrollView.contentOffset.y);
                endPoint=CGPointMake(scrollView.width, scrollView.contentOffset.y);
            }
            else
            {
                changeStart=CGPointMake(scrollView.width, scrollView.contentOffset.y);
                
                endPoint=CGPointMake(2*scrollView.width, scrollView.contentOffset.y);
            }
            
            if (startPointBlock!=nil) {
                
                startPointBlock(changeStart,endPoint);
            }

            

            if (boardBlock!=nil) {
                boardBlock();
            }
            
        }
        else if (moduleAnimationBlock!=nil) {
            CGFloat percent=fabs(off.x-changeStart.x)/fabs(endPoint.x-changeStart.x);
            NSUInteger exchangeIndex=[self arraCount:arrayDataCount index:*currentIndex+1];
            
            if (exchangeIndex==*currentIndex) {
                return;
            }
            
            moduleAnimationBlock(*currentIndex,exchangeIndex,percent);
        }
        
        

        
    }
    
    

}


+(void)currentIndex:(NSUInteger)currentIndex
         arrayCount:(NSUInteger)arrayCount
         scrollView:(UIScrollView *)scrollView
     slideSuperView:(CGFloat)slideViewWidth
        changeIndex:(CHANGEINDEXBLOCK)changeBlock
{
    
    if (changeBlock==nil) {
        return;
    }
    
    if (arrayCount<3) {
        
        [self minIndexJudege:currentIndex
                  arrayCount:arrayCount
                 scrollView:scrollView
                 changeIndex:changeBlock
              slideSuperView:slideViewWidth];
        
        return;
    }
    if (currentIndex==0) {
        
        HPNumber numberLeft=HPNumberMake(currentIndex, nil);
        HPNumber numberCentre=HPNumberMake(currentIndex+1, nil);
        HPNumber numberRight=HPNumberMake(currentIndex+2, nil);
        
        
        changeBlock(numberLeft,numberCentre,numberRight,scrollView.contentOffset);
        scrollView.contentOffset=CGPointMake(0, 0);
        return;
    }
    else if (currentIndex==arrayCount-1)
    {
        NSUInteger count=arrayCount-1;
        
        
        HPNumber numberLeft=HPNumberMake(count-2, nil);
        HPNumber numberCentre=HPNumberMake(count-1, nil);
        HPNumber numberRight=HPNumberMake(count, nil);
     
        changeBlock(numberLeft,numberCentre,numberRight,scrollView.contentOffset);
        scrollView.contentOffset=CGPointMake(2*slideViewWidth, 0);
        return;
    }
    
    HPNumber numberLeft=HPNumberMake(currentIndex-1, nil);
    HPNumber numberCentre=HPNumberMake(currentIndex, nil);
    HPNumber numberRight=HPNumberMake(currentIndex+1, nil);
    
    changeBlock(numberLeft,numberCentre,numberRight,scrollView.contentOffset);
    scrollView.contentOffset=CGPointMake(slideViewWidth, 0);
}

+(void)minIndexJudege:(NSUInteger )currentIndex
           arrayCount:(NSUInteger)arrayCount
           scrollView:(UIScrollView *)scrollView
          changeIndex:(CHANGEINDEXBLOCK)changeBlock
       slideSuperView:(CGFloat)slideViewWidth
{
    
    if (currentIndex<=1) {
        scrollView.contentOffset=CGPointMake(0, 0);
    }
    else
    {
        scrollView.contentOffset=CGPointMake(slideViewWidth, 0);
    }
    
    if (arrayCount==0) {
        return;
    }
    else if (arrayCount==1)
    {
        HPNumber numberLeft=HPNumberMake(0, nil);
        HPNumber numberCentre=HPNumberMake(-1, "Error:arrayCount very max");
        HPNumber numberRight=HPNumberMake(-1, "Error:arrayCount very max");
        changeBlock(numberLeft,numberCentre,numberRight,scrollView.contentOffset);
        
        return;
    }
    else if (arrayCount==2)
    {
        HPNumber numberLeft=HPNumberMake(0, nil);
        HPNumber numberCentre=HPNumberMake(1, nil);
        HPNumber numberRight=HPNumberMake(-1, "Error:arrayCount very max");
        changeBlock(numberLeft,numberCentre,numberRight,scrollView.contentOffset);
        return;
    }
    
}

+(void)animationSlideView:(UIView *)slideModule
         slideModuleWidht:(CGFloat)slideModuleWith
                   nowPoint:(HPPoint)nowPoint
                readyButton:(HPPoint)readyPoint
                movePercent:(CGFloat)movePercent
{
    CGFloat nowX=0;
    CGFloat nowWidth=0;
    
    CGFloat readyX=0;
    CGFloat readyWidth=0;
    
    if (slideModuleWith!=0) {
        nowX=nowPoint.x+((nowPoint.width-slideModuleWith)/2);
        nowWidth=slideModuleWith;
        
        readyX=readyPoint.x+((readyPoint.width-slideModuleWith)/2);
        readyWidth=slideModuleWith;
        
    }
    else
    {
        nowX=nowPoint.x;//+((nowPoint.width-slideModuleWith)/2);
        nowWidth=nowPoint.width;
        
        readyX=readyPoint.x;//+((readyPoint.width-slideModuleWith)/2);
        readyWidth=readyPoint.width;
        
    }
    
    
    CGFloat speace=fabs(readyX-nowX);
    
    if (movePercent>=0 && movePercent<=0.5)
    {
        
        movePercent=movePercent/0.5;
        
        
        CGFloat move=0;
        CGFloat width=0;
        CGFloat slideNowX=0;
        
        if (nowX>readyX) {
            move=(nowX-readyX)*movePercent;
//            slideNowX=nowPoint.x-move;
            slideNowX=nowX-move;
        }
        else
        {
            move=((speace-nowWidth)+readyWidth)*movePercent;
//            slideNowX=nowPoint.x;
            slideNowX=nowX;
        }
        
        width=nowWidth+move;
        
        slideModule.frame=CGRectMake(slideNowX, slideModule.y, width, slideModule.height);
        
        
    }
    else if (movePercent >0.5 && movePercent<=1)
    {
        
        CGFloat changeX=0.0;
        CGFloat changeWidth=0.0;
        CGFloat changeSpace=0.0;
        
        if (nowX>readyX) {
            
            movePercent=(1-movePercent)/0.5;
            
            changeX=readyX;
            changeSpace=readyWidth+((nowX-(readyX+readyWidth))+nowWidth)*movePercent;
            
        }
        else
        {
            movePercent=(movePercent-0.5)/0.5;
            
            changeX=nowX+(speace*movePercent);
            changeWidth=fabs(nowX-changeX);
            changeSpace=speace+readyWidth-changeWidth;
        }
        
        slideModule.frame=CGRectMake(changeX, slideModule.y, changeSpace, slideModule.height);
        
        
    }
}

+(void)slideModuleAlignCenter:(UIScrollView *)currentScrollerView
             slideModuleWithX:(CGFloat)slideModuleX
{
    
    CGFloat rightSide=currentScrollerView.contentSize.width-currentScrollerView.bounds.size.width;
    CGFloat centerHalf=currentScrollerView.bounds.size.width/2;

    if (slideModuleX>centerHalf  && slideModuleX<rightSide+centerHalf+10) {

        CGFloat centerWidth=slideModuleX-currentScrollerView.contentOffset.x;
        
        CGFloat center=centerWidth-centerHalf;
        
        [UIView animateWithDuration:0.25 animations:^{
            currentScrollerView.contentOffset=CGPointMake(currentScrollerView.contentOffset.x+(center/2), 0);
        }];
        
    }
    else if (slideModuleX<centerHalf)
    {
        [UIView animateWithDuration:0.25 animations:^{
            currentScrollerView.contentOffset=CGPointMake(0, 0);
        }];
    
    }
    else if (slideModuleX>rightSide+centerHalf+10 && currentScrollerView.contentSize.width>currentScrollerView.width)
    {
        [UIView animateWithDuration:0.25 animations:^{
            currentScrollerView.contentOffset=CGPointMake(rightSide, 0);
        }];

    }
    
}

@end
