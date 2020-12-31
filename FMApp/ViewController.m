//
//  ViewController.m
//  FMApp
//
//  Created by Prakash Maharjan on 8/18/17.
//  Copyright © 2017 Prakash Maharjan. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h> // importing AVFoundation and AVKit
#import <AVKit/AVKit.h>

//#define STREAMING_URL  @"http://rfcmedia.streamguys1.com/classicrock.mp3"
//Classic rock radio - United States

#define STREAMING_URL @"http://streaming.radionomy.com/JamendoLounge"

@interface ViewController ()

// instantiating player and player item
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
   
   // [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if (@available(iOS 10.0, *)) {
        //[[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionAllowAirPlay error:nil];
        [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionAllowAirPlay error:nil];
         //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
         [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    } else {
        // Fallback on earlier versions
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
         [[AVAudioSession sharedInstance] setActive: YES error: nil];
    }
   
   [self setUp];
}

-(void)setUp{
    // streaming URL
    //replace STREAMING_URL with your streaming URL
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:STREAMING_URL]];
    
    // notification to know playing status
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    // allocate player with player item
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.pauseButton.enabled = false;
    self.statusLabel.text = @"Streaming is paused.";
    self.player.volume = 0.50;
    [self getStatus];
    
}
-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    NSLog(@"finished playing playeritem");
    NSLog(@"userInfo:%@",notification.userInfo);
}
- (IBAction)Play:(id)sender {
    
    [self playFM];
    
}

-(void)playFM{
    //playing live stream from url
    [self setUp];
    [self.player play];
    self.playButton.enabled = false;
    self.pauseButton.enabled = true;
    self.statusLabel.text = @"Streaming...";
    [self getStatus];
}
- (IBAction)Pause:(id)sender {
    [self pauseFM];
}
-(void)pauseFM{
    
    //pause live stream from url
    [self.player pause];
    self.pauseButton.enabled = false;
    self.playButton.enabled = true;
    self.statusLabel.text = @"Streaming is paused.";
    [self getStatus];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderChanged:(UISlider *)sender {
    
    NSLog(@"volumeControlSlider-value: %f",self.volumeControlSlider.value);
    self.player.volume = self.volumeControlSlider.value;
    
}

-(void)getStatus{
    //NSLog(@"status:%ld",(long)self.player.timeControlStatus);
    NSLog(@"current time: %@",self.player.currentItem);
    NSLog(@"description:%@",self.player.currentItem.description);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [self playFM];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [self pauseFM];
        }
        
    }
}
@end
