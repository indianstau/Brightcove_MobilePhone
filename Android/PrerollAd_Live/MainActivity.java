package com.brightcove.prerollad_live;

import android.os.Bundle;
import android.text.format.DateUtils;
import android.util.Log;

import com.brightcove.ima.GoogleIMAComponent;
import com.brightcove.ima.GoogleIMAEventType;
import com.brightcove.player.event.Event;
import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.event.EventListener;
import com.brightcove.player.event.EventType;
import com.brightcove.player.media.DeliveryType;
import com.brightcove.player.mediacontroller.BrightcoveMediaController;
import com.brightcove.player.mediacontroller.BrightcoveSeekBar;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BaseVideoView;
import com.brightcove.player.view.BrightcoveExoPlayerVideoView;
import com.brightcove.player.view.BrightcovePlayer;

import com.google.ads.interactivemedia.v3.api.AdDisplayContainer;
import com.google.ads.interactivemedia.v3.api.AdsManager;
import com.google.ads.interactivemedia.v3.api.AdsRequest;
import com.google.ads.interactivemedia.v3.api.ImaSdkFactory;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends BrightcovePlayer {

    private final String TAG = this.getClass().getSimpleName();

    private EventEmitter eventEmitter;
    private GoogleIMAComponent googleIMAComponent;
    private String adRulesURL = "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=%2F15018773%2Feverything2&ciu_szs=300x250%2C468x60%2C728x90&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=dummy&correlator=[timestamp]&cmsid=133&vid=10XWSh7W4so&ad_rule=1";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        setContentView(R.layout.activity_main);
        brightcoveVideoView = (BrightcoveExoPlayerVideoView) findViewById(R.id.brightcove_video_view);

        setupAdMarkers(brightcoveVideoView);

        super.onCreate(savedInstanceState);
        eventEmitter = brightcoveVideoView.getEventEmitter();

        setupGoogleIMA();

                Video video = Video.createVideo("HLS_URL", DeliveryType.HLS);
                video.getProperties().put(Video.Fields.PUBLISHER_ID, "accound_id");
                brightcoveVideoView.add(video);
                brightcoveVideoView.start();

    private void setupGoogleIMA() {
        final ImaSdkFactory sdkFactory = ImaSdkFactory.getInstance();

        eventEmitter.on(EventType.AD_STARTED, new EventListener() {
            @Override
            public void processEvent(Event event) {
                Log.v(TAG, event.getType());
            }
        });

        eventEmitter.on(GoogleIMAEventType.DID_FAIL_TO_PLAY_AD, new EventListener() {
            @Override
            public void processEvent(Event event) {
                Log.v(TAG, event.getType());
            }
        });
        eventEmitter.on(EventType.AD_COMPLETED, new EventListener() {
            @Override
            public void processEvent(Event event) {
                Log.v(TAG, event.getType());
                brightcoveVideoView.stopPlayback();
                brightcoveVideoView.seekToLive();
            }
        });
        //solve the HLS with Token + Preroll ad problem 
        //when it play will stuck on android player.
        eventEmitter.on(EventType.ERROR, new EventListener(){
            @Override
            public void processEvent(Event event){
                System.out.print(event);
                Log.v("Error", event.toString());
                brightcoveVideoView.stopPlayback();
                brightcoveVideoView.seekToLive();
            }
        });
        eventEmitter.on(GoogleIMAEventType.ADS_REQUEST_FOR_VIDEO, new EventListener() {
            @Override
            public void processEvent(Event event) {
                AdDisplayContainer container = sdkFactory.createAdDisplayContainer();
                container.setPlayer(googleIMAComponent.getVideoAdPlayer());
                container.setAdContainer(brightcoveVideoView);

                AdsRequest adsRequest = sdkFactory.createAdsRequest();
                adsRequest.setAdTagUrl(adRulesURL);
                adsRequest.setAdDisplayContainer(container);

                ArrayList<AdsRequest> adsRequests = new ArrayList<AdsRequest>(1);
                adsRequests.add(adsRequest);

                event.properties.put(GoogleIMAComponent.ADS_REQUESTS, adsRequests);
                eventEmitter.respond(event);
            }
        });
        googleIMAComponent = new GoogleIMAComponent(brightcoveVideoView, eventEmitter, true);
    }

    private void setupAdMarkers(BaseVideoView videoView) {
        final BrightcoveMediaController mediaController = new BrightcoveMediaController(brightcoveVideoView);
        mediaController.addListener(GoogleIMAEventType.ADS_MANAGER_LOADED, new EventListener() {
            @Override
            public void processEvent(Event event) {
                AdsManager manager = (AdsManager) event.properties.get("adsManager");
                List<Float> cuepoints = manager.getAdCuePoints();
                for (int i = 0; i < cuepoints.size(); i++) {
                    Float cuepoint = cuepoints.get(i);
                    BrightcoveSeekBar brightcoveSeekBar = mediaController.getBrightcoveSeekBar();
                    int markerTime = cuepoint < 0 ? brightcoveSeekBar.getMax() : (int) (cuepoint * DateUtils.SECOND_IN_MILLIS);
                    mediaController.getBrightcoveSeekBar().addMarker(markerTime);
                }
            }
        });
        videoView.setMediaController(mediaController);
    }
}
