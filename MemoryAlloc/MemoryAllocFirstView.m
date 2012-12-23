//
//  MemoryAllocFirstView.m
//  MemoryAlloc
//
//  Created by 邱峰 on 12-11-28.
//  Copyright (c) 2012年 VioletHill. All rights reserved.
//

#import "MemoryAllocFirstView.h"

@implementation MemoryAllocFirstView


@synthesize memory=_memory;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) clearMemory
{
    [self.memory.useMemory removeAllObjects];
    [self.memory.freeMemory removeAllObjects];
    MemoryState *memory=[MemoryState alloc];
    memory->start=0;
    memory->memorySize=640;
    [self.memory.freeMemory addObject:memory];
    [self setNeedsDisplay];
}

-(void) addMemory:(MemoryState *)memory;
{

    if (self.memory==NULL)
    {
        self.memory=[[Memory alloc] init];
        [self clearMemory];
        self.memory.whoAmI=1;
    }
    
    int start=[self.memory applayMemory:memory->memorySize];
    if (start>=0)
    {
        [self.memory addMemoryIdNumber:memory->idNumber withMemorySize:memory->memorySize withMemoryStart:start];
    }
    [self setNeedsDisplay];
}

-(void) freeMemory:(int)idNumber
{
    [self.memory freeMemorywithIdNumber:idNumber];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rectangle=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);

    [[UIColor blueColor] set];
    
    MemoryState *memory;
    for (int i=0; i<[self.memory.useMemory count]; i++)
    {
        memory=(MemoryState *)[self.memory.useMemory objectAtIndex:i];
        CGRect rect=CGRectMake(0,memory->start, self.bounds.size.width,memory->memorySize);
        CGContextAddRect(context, rect);
        CGContextFillPath(context);
    }
    
    [[UIColor redColor] set];
    for (int i=0; i<[self.memory.useMemory count]; i++)
    {
        memory=(MemoryState *)[self.memory.useMemory objectAtIndex:i];
        CGContextMoveToPoint(context, 0, memory->start);
        CGContextAddLineToPoint(context, self.bounds.size.width, memory->start);
        CGContextStrokePath(context);
    }
}


@end
