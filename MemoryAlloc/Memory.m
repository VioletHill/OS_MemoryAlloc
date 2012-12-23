//
//  Memory.m
//  MemoryAlloc
//
//  Created by 邱峰 on 12-11-28.
//  Copyright (c) 2012年 VioletHill. All rights reserved.
//

#import "Memory.h"
#import "MemoryState.h"



@implementation Memory

@synthesize whoAmI=_whoAmI;
@synthesize freeMemory=_freeMemory;
@synthesize useMemory=_useMemory;

-(id) init
{
    _freeMemory=[NSMutableArray arrayWithCapacity:20];
    _useMemory=[NSMutableArray arrayWithCapacity:20];
    return self;
}

- (int) applayMemory:(int)memorySize
{
    MemoryState *memory;
    if (_whoAmI==1)
    {
        for (int i=0; i<[_freeMemory count]; i++)
        {
            memory=(MemoryState *)[_freeMemory objectAtIndex:i];
            if ( memory->memorySize>=memorySize )
            {
                int start=memory->start;
                if (memory->memorySize>memorySize)
                {
                    memory->memorySize-=memorySize;
                    memory->start+=memorySize;
                }
                else [_freeMemory removeObjectAtIndex:i];
                return start;
            }
        }
    }
    if (_whoAmI==2)
    {
        int minWaster=1<<20;
        int which=-1;
        for (int i=0; i<[_freeMemory count]; i++)
        {
            memory=(MemoryState *)[_freeMemory objectAtIndex:i];
            if (memory->memorySize>=memorySize)
            {
                if (memory->memorySize-memorySize<minWaster)
                {
                    minWaster=memory->memorySize-memorySize;
                    which=i;
                }
            }
        }
        if (which!=-1)
        {
            memory=(MemoryState *)[_freeMemory objectAtIndex:which];
            int start=memory->start;
            if (minWaster!=0)
            {
                memory->memorySize-=memorySize;
                memory->start+=memorySize;
            }
            else [_freeMemory removeObjectAtIndex:which];
            return start;
        }
    }
    return -1;
}

-(void) addMemoryIdNumber:(int)idNumber withMemorySize:(int)memorySize withMemoryStart:(int)start
{
    MemoryState *memory;
    MemoryState *newMemory;

    newMemory=[[MemoryState alloc] init];
    newMemory->start=start;
    newMemory->memorySize=memorySize;
    newMemory->idNumber=idNumber;
    
    for (int i=0; i<[_useMemory count]; i++)
    {
        memory=(MemoryState *)[_useMemory objectAtIndex:i];
        if (memory->start>start)
        {
            [_useMemory insertObject:(id)newMemory atIndex:i];
            return ;
        }
    }
    [_useMemory addObject:(id)newMemory];
}

-(int) lastFree:(int) start
{
    MemoryState *memory;
    for (int i=0; i<[_freeMemory count]; i++)
    {
        memory=(MemoryState *)[_freeMemory objectAtIndex:i];
        if (memory->start+memory->memorySize==start) return i;
    }
    return -1;
}

-(int) nextFree:(int) start
{
    MemoryState *memory;
    for (int i=0; i<[_freeMemory count]; i++)
    {
        memory=(MemoryState *)[_freeMemory objectAtIndex:i];
        if (memory->start==start) return i;
    }
    return -1;
}

- (void) freeMemorywithIdNumber:(int)idNumber
{
    MemoryState *useMemoryInstance;
    int indexLastFree;
    int indexNextFree;
    int indexUse;
    for (int i=0; i<[_useMemory count]; i++)
    {
        useMemoryInstance=(MemoryState *)[_useMemory objectAtIndex:i];
        if (useMemoryInstance->idNumber==idNumber)
        {
            indexUse=i;
            [_useMemory removeObjectAtIndex:indexUse];
            break;
        }
    }
    
    indexLastFree=[self lastFree:useMemoryInstance->start];
    indexNextFree=[self nextFree:useMemoryInstance->start+useMemoryInstance->memorySize];
    
    if (indexLastFree!=-1 && indexNextFree!=-1)     //上中下合并
    {
        MemoryState *memory=(MemoryState *)[_freeMemory objectAtIndex:indexLastFree];
        memory->memorySize+=useMemoryInstance->memorySize+((MemoryState *) [_freeMemory objectAtIndex:indexNextFree])->memorySize;
        [_freeMemory removeObjectAtIndex:indexNextFree];
        return ;
    }
    
    if (indexLastFree!=-1)                          //上中合并
    {
        MemoryState  *memory=(MemoryState *)[_freeMemory objectAtIndex:indexLastFree];
        memory->memorySize+=useMemoryInstance->memorySize;
        return ;
    }
    
    if (indexNextFree!=-1)                      //中下合并
    {
        MemoryState  *memory=(MemoryState *)[_freeMemory objectAtIndex:indexNextFree];
        memory->memorySize+=useMemoryInstance->memorySize;
        memory->start=useMemoryInstance->start;
        return ;
    }
    
    for (int i=0; i<[_freeMemory count]; i++)
    {
        MemoryState  *memory=(MemoryState *)[_freeMemory objectAtIndex:i];
        if (memory->start>useMemoryInstance->start)
        {
            [_freeMemory insertObject:(id)useMemoryInstance atIndex:i];
            return ;
        }
    }
    [_freeMemory addObject:(id)useMemoryInstance];
}

@end
