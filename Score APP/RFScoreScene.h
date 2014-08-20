//
//  RFScoreScene.h
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RFViewController.h"


@interface RFScoreScene : SKScene

@property (weak, nonatomic) RFViewController *parentViewController;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

-(void)restartPlayer;
-(void)toggleAnalysis;

@end
