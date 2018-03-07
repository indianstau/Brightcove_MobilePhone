//
//  ViewController.m
//  CocoapodsTest
//
//  Created by San on 2018/3/1.
//  Copyright © 2018年 Brightcove. All rights reserved.
//

#import "ViewController.h"

static NSString * const kViewControllerPlaybackServicePolicyKey = @" PolicyKey ";
static NSString * const kViewControllerAccountID = @" AccountID ";
static NSString * const kViewControllerVideoID = @" VideoID ";

@interface ViewController () <BCOVPlaybackControllerDelegate>


@property (nonatomic, strong) BCOVPlaybackService *playbackService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;
@property (nonatomic) BCOVPUIPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView *videoContainer;
@end

@implementation ViewController
#pragma mark Setup Methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _playbackController = [BCOVPlayerSDKManager.sharedManager createPlaybackController];
    
    _playbackController.analytics.account = kViewControllerAccountID; // Optional
    
    _playbackController.delegate = self;
    _playbackController.autoAdvance = YES;
    _playbackController.autoPlay = YES;
    
    _playbackService = [[BCOVPlaybackService alloc] initWithAccountId:kViewControllerAccountID policyKey:kViewControllerPlaybackServicePolicyKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up our player view. Create with a standard VOD layout.
    BCOVPUIPlayerView *playerView = [[BCOVPUIPlayerView alloc] initWithPlaybackController:self.playbackController options:nil controlsView:[BCOVPUIBasicControlView basicControlViewWithVODLayout] ];
    
    // Install in the container view and match its size.
    playerView.frame = _videoContainer.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_videoContainer addSubview:playerView];
    _playerView = playerView;
    
    // Associate the playerView with the playback controller.
    _playerView.playbackController = _playbackController;
    
    [self requestContentFromPlaybackService];
}

- (void)requestContentFromPlaybackService
{
    [self.playbackService findVideoWithVideoID:kViewControllerVideoID parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        if (video)
        {
            [self.playbackController setVideos:@[ video ]];
        }
        else
        {
            NSLog(@"ViewController Debug - Error retrieving video: `%@`", error);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
