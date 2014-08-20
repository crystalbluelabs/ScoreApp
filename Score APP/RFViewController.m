//
//  RFViewController.m
//  Score APP
//
//  Created by DJ on 2/11/14.
//  Copyright (c) 2014 Refiners Fire. All rights reserved.
//

#import "RFViewController.h"
#import "RFVideoScene.h"
#import "RFScoreScene.h"
#import "RFSynopsisScene.h"
#import "RFPurchaseScene.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

// Defines
#define VIDEO_SCENE    1
#define SCORE_SCENE    2
#define LESSON_SCENE   3
#define PURCHASE_SCENE 4

#define BACKGROUND_COLOR [SKColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]

static const int buttonWidthRight = 49;

@implementation RFViewController {
    BOOL _menuVisible;
    BOOL _leftVisible;
    //BOOL _isPlaying;
    int _currentScene;
    
    NSString *_path;
    AVPlayerItem *_videoItem;
    AVQueuePlayer *_queuePlayer;
    AVPlayerLayer *_layer;
    CALayer *_layerUI;
    CALayer *_dot;
    
    float _dotX;
    float _duration;
    float _currentPos;
    NSInteger _layerUIWidth;
    
    RFScoreScene *_scoreScene;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Setup instance variables.
    
    self.movement = 0;
    _leftVisible = YES;
    _menuVisible = YES;
    _currentScene = SCORE_SCENE;
    [_scoreButton setImage:[UIImage imageNamed:@"scoreButtonActive"] forState:UIControlStateNormal];
    self.showScore = YES;
    
    //[self toggleMovementBar:0.5];
    [_preludeButton setImage:[UIImage imageNamed:@"preludeButtonActive"] forState:UIControlStateNormal];

    // Configure the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    //_videoScene = [RFVideoScene sceneWithSize:skView.bounds.size];
    //_videoScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    
    
    _scoreScene = [RFScoreScene sceneWithSize:skView.bounds.size];
    _scoreScene.parentViewController = self;
    
    [skView presentScene:_scoreScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Logic Functions

- (float)easingOutBounce:(float)x
            currentTime:(float)t
         beginningValue:(float)b
            currentTime:(float)c
               duration:(float)d
{
/*    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }*/
    return 1.1;
}

- (void)updatePlayerPOS
{
    _currentPos = CMTimeGetSeconds(_queuePlayer.currentItem.currentTime);
    if (_isPlaying) {
        _dotX = (_currentPos / _duration) * _layerUIWidth;
        _dot.frame = CGRectMake(_dotX, 0, 5, 5);
    }
    if(_leftVisible) {
        _layerUIWidth = 470;
        _dotX = (_currentPos / _duration) * _layerUIWidth;
        _layerUI.frame = CGRectMake(49, 0, _layerUIWidth, 2);
        _dot.frame = CGRectMake(_dotX+49, 0, 5, 5);
    } else {
        _layerUIWidth = 519;
        _dotX = (_currentPos / _duration) * _layerUIWidth;
        _layerUI.frame = CGRectMake(0, 0, _layerUIWidth, 2);
        _dot.frame = CGRectMake(_dotX, 0, 5, 5);
    }
}

-(void)toggleMovementBar:(float)duration
{
    if(_leftVisible) {
        [UIView animateWithDuration:duration animations:^{
            _preludeButton.frame = CGRectMake(_preludeButton.frame.origin.x-buttonWidthRight,_preludeButton.frame.origin.y,buttonWidthRight,107);
            _fugueButon.frame = CGRectMake(_fugueButon.frame.origin.x-buttonWidthRight,_fugueButon.frame.origin.y,buttonWidthRight,107);
            _annotationButton.frame = CGRectMake(_annotationButton.frame.origin.x-buttonWidthRight,_annotationButton.frame.origin.y,buttonWidthRight,107);
            _toggleButtonLeft.frame = CGRectMake(_toggleButtonLeft.frame.origin.x-buttonWidthRight,_toggleButtonLeft.frame.origin.y,50,320);
        }];
        _leftVisible = NO;
    } else {
        [UIView animateWithDuration:duration animations:^{
            _preludeButton.frame = CGRectMake(_preludeButton.frame.origin.x+buttonWidthRight,_preludeButton.frame.origin.y,buttonWidthRight,107);
            _fugueButon.frame = CGRectMake(_fugueButon.frame.origin.x+buttonWidthRight,_fugueButon.frame.origin.y,buttonWidthRight,107);
            _annotationButton.frame = CGRectMake(_annotationButton.frame.origin.x+buttonWidthRight,_annotationButton.frame.origin.y,buttonWidthRight,107);
            _toggleButtonLeft.frame = CGRectMake(_toggleButtonLeft.frame.origin.x+buttonWidthRight,_toggleButtonLeft.frame.origin.y,50,320);
        }];
        _leftVisible = YES;
    }
}

-(void)toggleNavMenu
{
    if(_menuVisible) {
        [UIView animateWithDuration:0.5 animations:^{
            _purchaseButton.frame = CGRectMake(_purchaseButton.frame.origin.x+buttonWidthRight,_purchaseButton.frame.origin.y,49,66);
            _restartButton.frame = CGRectMake(_restartButton.frame.origin.x+buttonWidthRight,_restartButton.frame.origin.y,49,66);
            _scoreButton.frame = CGRectMake(_scoreButton.frame.origin.x+buttonWidthRight,_scoreButton.frame.origin.y,49,66);
            _synopsisButton.frame = CGRectMake(_synopsisButton.frame.origin.x+buttonWidthRight,_synopsisButton.frame.origin.y,49,66);
            _playButton.frame = CGRectMake(_playButton.frame.origin.x+buttonWidthRight,_playButton.frame.origin.y,52,60);
            _toggleButton.frame = CGRectMake(_toggleButton.frame.origin.x+buttonWidthRight,_toggleButton.frame.origin.y,50,320);
        }];
        _menuVisible = NO;
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _purchaseButton.frame = CGRectMake(_purchaseButton.frame.origin.x-buttonWidthRight,_purchaseButton.frame.origin.y,49,66);
            _restartButton.frame = CGRectMake(_restartButton.frame.origin.x-buttonWidthRight,_restartButton.frame.origin.y,49,66);
            _scoreButton.frame = CGRectMake(_scoreButton.frame.origin.x-buttonWidthRight,_scoreButton.frame.origin.y,49,66);
            _synopsisButton.frame = CGRectMake(_synopsisButton.frame.origin.x-buttonWidthRight,_synopsisButton.frame.origin.y,49,66);
            _playButton.frame = CGRectMake(_playButton.frame.origin.x-buttonWidthRight,_playButton.frame.origin.y,52,60);
            _toggleButton.frame = CGRectMake(_toggleButton.frame.origin.x-buttonWidthRight,_toggleButton.frame.origin.y,50,320);
        }];
        _menuVisible = YES;
    }
}

-(void)setPlayPauseImage:(NSString *)set
{
    if([set  isEqual: @"play"]) {
        [_playButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    } else {
        [_playButton setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
    }
}

#pragma mark - Toggle Menu IBActions

- (IBAction)toggleMovement:(id)sender {
    [self toggleMovementBar:0.5];
}

- (IBAction)toggleTabBar:(id)sender {
    [self toggleNavMenu];
}

#pragma mark - Button Press IBActions

- (IBAction)preludeButtonPress:(id)sender {
    [_preludeButton setImage:[UIImage imageNamed:@"preludeButtonActive"] forState:UIControlStateNormal];
    [_fugueButon setImage:[UIImage imageNamed:@"fugueButton"] forState:UIControlStateNormal];
    self.movement = 0;
}

- (IBAction)fugueButtonPress:(id)sender {
    [_preludeButton setImage:[UIImage imageNamed:@"preludeButton"] forState:UIControlStateNormal];
    [_fugueButon setImage:[UIImage imageNamed:@"fugueButtonActive"] forState:UIControlStateNormal];
    self.movement = 1;
}

- (IBAction)annotationButtonPress:(id)sender {
    [_preludeButton setImage:[UIImage imageNamed:@"preludeButton"] forState:UIControlStateNormal];
    [_fugueButon setImage:[UIImage imageNamed:@"fugueButton"] forState:UIControlStateNormal];
    [_scoreScene toggleAnalysis];
}


- (IBAction)playButtonPress:(id)sender {
    if(!self.isPlaying) {
        [_scoreScene.audioPlayer play];
        self.isPlaying = YES;
        
        [self setPlayPauseImage:@"pause"];
    } else {
        [_scoreScene.audioPlayer pause];
        self.isPlaying = NO;
        
        [self setPlayPauseImage:@"play"];
    }
    
}

- (IBAction)scoreButtonPress:(id)sender {
    if (_currentScene != SCORE_SCENE) {
        [_scoreButton setImage:[UIImage imageNamed:@"scoreButtonActive"] forState:UIControlStateNormal];
        [_synopsisButton setImage:[UIImage imageNamed:@"synopsisButton"] forState:UIControlStateNormal];
        [_restartButton setImage:[UIImage imageNamed:@"restartButton"] forState:UIControlStateNormal];
        [_purchaseButton setImage:[UIImage imageNamed:@"purchaseButton"] forState:UIControlStateNormal];

        if (_currentScene != VIDEO_SCENE)
        {
            SKView *skView = (SKView *)self.view;
            _currentScene = SCORE_SCENE;
            [skView presentScene:_scoreScene];
        } else {
            _currentScene = SCORE_SCENE;
            self.showScore = YES;
        }
    }
}

- (IBAction)restartButtonPress:(id)sender {
    [_scoreScene restartPlayer];
}


- (IBAction)synopsisButtonPress:(id)sender
{
    if (_currentScene != LESSON_SCENE) {
        [_scoreButton setImage:[UIImage imageNamed:@"scoreButton"] forState:UIControlStateNormal];
        [_synopsisButton setImage:[UIImage imageNamed:@"synopsisButtonActive"] forState:UIControlStateNormal];
        [_restartButton setImage:[UIImage imageNamed:@"restartButton"] forState:UIControlStateNormal];
        [_purchaseButton setImage:[UIImage imageNamed:@"purchaseButton"] forState:UIControlStateNormal];
        
        SKView *skView = (SKView *)self.view;
        RFSynopsisScene *synopsisScene = [RFSynopsisScene sceneWithSize:skView.bounds.size];
        synopsisScene.scaleMode = SKSceneScaleModeAspectFill;
        _currentScene = PURCHASE_SCENE;
        //[[skView.subviews lastObject] removeFromParent];
        [skView presentScene:synopsisScene];
        _leftVisible = NO;
    }
}

- (IBAction)purchaseButtonPress:(id)sender {
    if (_currentScene != PURCHASE_SCENE) {
        [_scoreButton setImage:[UIImage imageNamed:@"scoreButton"] forState:UIControlStateNormal];
        [_synopsisButton setImage:[UIImage imageNamed:@"synopsisButton"] forState:UIControlStateNormal];
        [_restartButton setImage:[UIImage imageNamed:@"restartButton"] forState:UIControlStateNormal];
        [_purchaseButton setImage:[UIImage imageNamed:@"purchaseButtonActive"] forState:UIControlStateNormal];
        
        SKView *skView = (SKView *)self.view;
        RFPurchaseScene *purchaseScene = [RFPurchaseScene sceneWithSize:skView.bounds.size];
        purchaseScene.scaleMode = SKSceneScaleModeAspectFill;
        _currentScene = PURCHASE_SCENE;
        //[[skView.subviews lastObject] removeFromParent];
        [skView presentScene:purchaseScene];
        _leftVisible = NO;
    }
}


@end
