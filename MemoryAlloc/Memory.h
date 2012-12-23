//
//  Memory.h
//  MemoryAlloc
//
//  Created by 邱峰 on 12-11-28.
//  Copyright (c) 2012年 VioletHill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memory : NSObject

@property (nonatomic) NSMutableArray *freeMemory;
@property (nonatomic) NSMutableArray *useMemory;
@property (nonatomic) int whoAmI;

- (int) applayMemory:(int)sizeMemory;
-(void) addMemoryIdNumber:(int)idNumber withMemorySize:(int)sizeMemroy withMemoryStart:(int)start;
- (void) freeMemorywithIdNumber:(int)idNumber;

@end
