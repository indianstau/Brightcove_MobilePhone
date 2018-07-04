//
//  ViewController.swift
//  Ana_application_S
//
//  Created by San on 2018/7/3.
//  Copyright © 2018年 Brightcove. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

let kViewControllerPlaybackServicePolicyKey = "policy_key"
let kViewControllerAccountID = ""
let kViewControllerVideoID = ""

class ViewController: UIViewController, BCOVPlaybackControllerDelegate {
    
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    let playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)!
    let playbackController :BCOVPlaybackController
    @IBOutlet weak var videoContainerView: UIView!
    

    
    required init?(coder aDecoder: NSCoder) {
        playbackController = (sharedSDKManager?.createPlaybackController())!
        
        super.init(coder: aDecoder)
        
        playbackController.analytics.account = kViewControllerAccountID
        
        playbackController.delegate = self
        playbackController.isAutoAdvance = true
        playbackController.isAutoPlay = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set up our player view. Create with a standard VOD layout.
        let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: nil, controlsView: BCOVPUIBasicControlView.withVODLayout())
        
        // Install in the container view and match its size.
        playerView?.frame = self.videoContainerView.bounds
        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.videoContainerView.addSubview(playerView!)
        
        // Associate the playerView with the playback controller.
        playerView?.playbackController = playbackController
        
        requestContentFromPlaybackService()
    }
    
    func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: kViewControllerVideoID, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
            
            if let v = video {
                self.playbackController.setVideos([v] as NSArray)
            } else {
                print("ViewController Debug - Error retrieving video: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, didAdvanceTo session: BCOVPlaybackSession!) {
        print("Advanced to new session")
    }
    
    private func playbackController(_ controller: BCOVPlaybackController!, playbacksession session: BCOVPlaybackSession!, didProgressTo progress: TimeInterval){
        print("Progress: \(progress) seconds")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

