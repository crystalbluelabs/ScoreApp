//
//  RFPurchaseScene.m
//  Score APP
//
//  Created by DJ on 2/16/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFPurchaseScene.h"
#define BACKGROUND_COLOR [SKColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]
#define FONT_COLOR [SKColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0]

static const float sizeX = 140;
static const float sizeY = 140;

@implementation RFPurchaseScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = BACKGROUND_COLOR;
        [self addPieceImage];
        [self addTitleText];
        [self addFooterText];
        [self addButtons];
        
    }
    return self;
}

-(void)addButtons
{
    CGSize buttonSize;
    
    SKSpriteNode *purchaseButton = [[SKSpriteNode alloc] initWithImageNamed:@"bPurchaseButton"];
    buttonSize = CGSizeMake(purchaseButton.size.width / 2, purchaseButton.size.height / 2);
    purchaseButton.size = buttonSize;
    purchaseButton.position = CGPointMake((self.frame.size.width / 2) - (buttonSize.width / 2) - 20,
                                          (self.frame.size.height / 3));
    [self addChild:purchaseButton];
    
    SKSpriteNode *restoreButton = [[SKSpriteNode alloc] initWithImageNamed:@"bRestoreButton"];
    restoreButton.size = buttonSize;
    restoreButton.position = CGPointMake((self.frame.size.width / 2) + (buttonSize.width / 2) + 20,
                                         (self.frame.size.height / 3));
    [self addChild:restoreButton];
}

-(void)addFooterText
{
    SKLabelNode *greatMusicMatters = [[SKLabelNode alloc] init];
    greatMusicMatters.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height * .1);
    greatMusicMatters.text = @"Great Music Matters!";
    greatMusicMatters.fontSize = 20;
    greatMusicMatters.fontColor = FONT_COLOR;
    [self addChild:greatMusicMatters];
    
    
}

-(void)addTitleText
{
    SKLabelNode *pieceTitle = [[SKLabelNode alloc] init];
    pieceTitle.position = CGPointMake(self.frame.size.width * .3 + 187, self.frame.size.height - 40);
    pieceTitle.text = @"Prelude And Fugue in C";
    pieceTitle.fontColor = FONT_COLOR;
    pieceTitle.fontSize = 20;
    [self addChild:pieceTitle];
    
    SKLabelNode *pieceSubTitle = [[SKLabelNode alloc] init];
    pieceSubTitle.position = CGPointMake(self.frame.size.width * .3 + 185, self.frame.size.height - 63);
    pieceSubTitle.text = @"Johann Sebastian Bach";
    pieceSubTitle.fontColor = FONT_COLOR;
    pieceSubTitle.fontSize = 20;
    [self addChild:pieceSubTitle];
}

-(void)addPieceImage {
    SKSpriteNode *pieceCircle = [[SKSpriteNode alloc] initWithImageNamed:@"LintonCircle"];
    CGSize circleSize = CGSizeMake(sizeX,sizeY);
    pieceCircle.size = circleSize;
    pieceCircle.position = CGPointMake(self.frame.size.width * .3, (self.frame.size.height - pieceCircle.size.height / 2) - 10);
    [self addChild:pieceCircle];
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
