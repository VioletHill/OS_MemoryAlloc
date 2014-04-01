//
//  ViewController.m
//  MemoryAlloc
//
//  Created by 邱峰 on 12-11-28.
//  Copyright (c) 2012年 VioletHill. All rights reserved.
//

#import "ViewController.h"
#import "MemoryAllocBestView.h"
#import "MemoryAllocFirstView.h"
#import "MemoryState.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *firstDemoLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestDemoLabel;

@property (strong, nonatomic) IBOutlet MemoryAllocFirstView *memoryFirstView;
@property (strong, nonatomic) IBOutlet MemoryAllocBestView *memoryBestView;

@property (strong, nonatomic) IBOutlet UIButton *memoryFirstDemoByHand;
@property (strong, nonatomic) IBOutlet UIButton *memoryBestDemoByHand;
@end

@implementation ViewController
{
    int memorySize[11];
    int type[11];
    int idNumber[11];
    int firstCount;
    int bestCount;
    BOOL isFirstDemoByHand;
    BOOL isBestDemoByHand;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    memorySize[0]=130;        type[0]=1;  idNumber[0]=1;
    memorySize[1]=60;         type[1]=1;  idNumber[1]=2;
    memorySize[2]=100;        type[2]=1;  idNumber[2]=3;
    memorySize[3]=60;         type[3]=0;  idNumber[3]=2;
    memorySize[4]=200;        type[4]=1;  idNumber[4]=4;
    memorySize[5]=100;        type[5]=0;  idNumber[5]=3;
    memorySize[6]=130;        type[6]=0;  idNumber[6]=1;
    memorySize[7]=140;        type[7]=1;  idNumber[7]=5;
    memorySize[8]=60;         type[8]=1;  idNumber[8]=6;
    memorySize[9]=50;         type[9]=1;  idNumber[9]=7;
    memorySize[10]=60;        type[10]=0; idNumber[10]=6;

	// Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)bestStart:(UIButton *)sender
{
    NSString *label;
    label=[NSString stringWithFormat:@"%@%d:  ", @"步骤",bestCount+1];
    if (bestCount==11)
    {
        label=@"演示结束，内存被清空";
        bestCount=0;
        [self.memoryBestView clearMemory];
    }
    else
    {
        MemoryState *memory=[MemoryState alloc];
        memory->idNumber=idNumber[bestCount];
        memory->memorySize=memorySize[bestCount];
        if (type[bestCount]==1)
        {
            [self.memoryBestView addMemory:memory];
            label=[label stringByAppendingFormat:@"作业%d  申请%dk",memory->idNumber,memory->memorySize];
        }
        else
        {
            [self.memoryBestView freeMemory:memory->idNumber];
            label=[label stringByAppendingFormat:@"作业%d  释放%dk",memory->idNumber,memory->memorySize];
        }
        bestCount++;
    }
    
    [self.bestDemoLabel setText:label];
}

-(void) bestAutomaticStart
{
    [self bestStart:nil];
    if (bestCount!=0)  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(bestAutomaticStart) userInfo:NULL repeats:NO];
    else
    {
        [self.memoryBestDemoByHand setEnabled:true];
        isBestDemoByHand=false;
    }

}

- (IBAction)bestAutomatic:(UIButton *)sender
{
    if (isBestDemoByHand) return;
    isBestDemoByHand=true;
    [self.memoryBestDemoByHand setEnabled:false];
    bestCount=0;
    [self.memoryBestView clearMemory];
    [self bestAutomaticStart];
}

- (IBAction)firstStart:(UIButton *)sender
{
    NSString *label;
    label=[NSString stringWithFormat:@"%@%d:  ", @"步骤",firstCount+1];
    if (firstCount==11)
    {
        label=@"演示结束，内存被清空";
        firstCount=0;
        [self.memoryFirstView clearMemory];
    }
    else
    {
        MemoryState *memory=[MemoryState alloc];
        memory->idNumber=idNumber[firstCount];
        memory->memorySize=memorySize[firstCount];
        if (type[firstCount]==1)
        {
            [self.memoryFirstView addMemory:memory];
            label=[label stringByAppendingFormat:@"作业%d  申请%dk",memory->idNumber,memory->memorySize];
        }
        else
        {
            [self.memoryFirstView freeMemory:memory->idNumber];
            label=[label stringByAppendingFormat:@"作业%d  释放%dk",memory->idNumber,memory->memorySize];
        }
        firstCount++;
    }
    
    [self.firstDemoLabel setText:label];
}

-(void) firstAutomaticStart
{
    [self firstStart:nil];
    if (firstCount!=0)  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(firstAutomaticStart) userInfo:NULL repeats:NO];
    else
    {
        [self.memoryFirstDemoByHand setEnabled:true];
        isFirstDemoByHand=false;
    }
    
}

- (IBAction)firstAutomatic:(UIButton *)sender
{
    if (isFirstDemoByHand) return;
    isFirstDemoByHand=true;
    [self.memoryFirstDemoByHand setEnabled:false];
    firstCount=0;
    [self.memoryFirstView clearMemory];
    [self firstAutomaticStart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return false;
}


@end
