package com.brightcove.live;

import android.os.Bundle;

import com.brightcove.player.media.DeliveryType;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcoveExoPlayerVideoView;
import com.brightcove.player.view.BrightcovePlayer;


public class MainActivity extends BrightcovePlayer {

    private final String TAG = this.getClass().getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_main);
        brightcoveVideoView = (BrightcoveExoPlayerVideoView) findViewById(R.id.brightcove_video_view);
        super.onCreate(savedInstanceState);

        Video video = Video.createVideo("HLS_URL", DeliveryType.HLS);
        video.getProperties().put(Video.Fields.PUBLISHER_ID, "accound_id");
        brightcoveVideoView.add(video);
        brightcoveVideoView.start();
    }
}
