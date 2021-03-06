//
//  MemoryAllocFirstView.h
//  MemoryAlloc
//
//  Created by 邱峰 on 12-11-28.
//  Copyright (c) 2012年 VioletHill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"
#import "MemoryState.h"

@interface MemoryAllocFirstView : UIView
@property (nonatomic) Memory *memory;

-(void) addMemory:(MemoryState *)memory;
-(void) freeMemory:(int)idNumber;
-(void) clearMemory;
@end
