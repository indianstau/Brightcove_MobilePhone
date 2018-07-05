//
//  ViewController.m
//  Ana_application
//
//  Created by San on 2018/7/2.
//  Copyright © 2018年 Brightcove. All rights reserved.
//

#import "ViewController.h"

static NSString * const kViewControllerPlaybackServicePolicyKey = @"";
static NSString * const kViewControllerAccountID = @"";
static NSString * const kViewControllerVideoID = @"";

@interface ViewController () <BCOVPlaybackControllerDelegate>

@property (nonatomic, strong) BCOVPlaybackService * playbackService;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;

//id<BCOVPlaybackController> controller = [[BCOVPlayerSDKManager sharedManager] createPlaybackController];
//controller.analytics.account = @"";
//controller.analytics.destination = @"";
//controller.analytics.source = @"";

@property (nonatomic, strong) BCOVPUIPlayerView * playerView;
@property (nonatomic, weak) IBOutlet UIView * videoContainer;

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
    // line 47-50 有改 加入 line 58-60
    //_playbackController = [BCOVPlayerSDKManager.sharedManager createPlaybackController];
    
    BCOVPlayerSDKManager *manager =[BCOVPlayerSDKManager sharedManager];
    _playbackController = [manager createPlaybackControllerWithViewStrategy:nil];
//     _playbackController = [manager createPlaybackControllerWithViewStrategy:[manager defaultControlsViewStrategy]];
    
    _playbackController.analytics.account = kViewControllerAccountID; // optional
    
    _playbackController.delegate = self;
    _playbackController.autoAdvance = YES;
    _playbackController.autoPlay = YES;
    
    _playbackController.analytics.account = @"";
    _playbackController.analytics.destination = @"";
    _playbackController.analytics.source = @"";
    
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
