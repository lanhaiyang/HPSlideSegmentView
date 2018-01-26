//
//  HPKVOMange.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/8/30.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPKVOMange.h"

@interface HPKVOMange ()

@property(nonatomic,strong) NSMutableArray *kvos;

@end

@implementation HPKVOMange

-(instancetype)init
{
    if (self=[super init]) {
        
        _kvos=self.kvos;
        
    }
    return self;
}


-(void)addObserverWithObject:(id)observerObject  blockWeak:(id)weakObj addObserver:(KVOMangeBlock)block
{
    
    if (observerObject==nil) {
        return;
    }
    
    if ([self containObserverWithObject:observerObject]) {
        return;
    }
    
    
    if (block!=nil) {
        
        block(weakObj);
        [_kvos addObject:observerObject];
    }
    
}

-(BOOL)containObserverWithObject:(id)observerObject
{
    if (observerObject==nil) {
        return NO;
    }
    
    return [_kvos containsObject:observerObject];
}

-(void)removeObserverWithObject:(id)observerObject blockWeak:(id)weakObj addObserver:(KVOMangeBlock)block
{

    
    if ([self containObserverWithObject:observerObject]) {
        
        [_kvos removeObject:observerObject];
        
        if (block!=nil) {
            block(weakObj);
        }
        
    }
    
}

-(NSMutableArray *)kvos
{
    if (_kvos==nil) {
        _kvos=[NSMutableArray array];
    }
    return _kvos;
}

@end
