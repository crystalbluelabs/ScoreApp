//
//  RFLessonScene.m
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFSynopsisScene.h"
#define BACKGROUND_COLOR [SKColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]
#define FONT_COLOR [SKColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0]


@implementation RFSynopsisScene
{
    SKNode *_sceneNode;
    
    SKSpriteNode *_synopsis;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = BACKGROUND_COLOR;
        [self setupScene];
    }
    return self;
}

-(void)setupScene
{
    _sceneNode = [SKNode node];
    [self addChild:_sceneNode];
    
    _synopsis = [[SKSpriteNode alloc] initWithImageNamed:@"Synopsis"];
    _synopsis.anchorPoint = CGPointMake(0,1);
    _synopsis.position = CGPointMake(0, self.size.height);
    _synopsis.size = CGSizeMake(568, 320);
    [_sceneNode addChild:_synopsis];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
     
     }*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
