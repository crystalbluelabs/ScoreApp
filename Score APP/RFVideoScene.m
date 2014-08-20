//
//  RFMyScene.m
//  Score APP
//
//  Created by DJ on 2/11/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFVideoScene.h"
#import "RFViewController.h"
#import "RFScoreScene.h"
#import <AVFoundation/AVFoundation.h>
#define BACKGROUND_COLOR [SKColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]

@implementation RFVideoScene {
    float _lastUpdateTime;
    float _dt;
    
    AVPlayer *_player;
    SKVideoNode *_videoNode;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        
    }
    return self;
}

-(void)initializeScene
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
        
    }*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
}

@end
