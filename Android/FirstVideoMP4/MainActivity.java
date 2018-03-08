package com.example.san.mytest;

import android.os.Bundle;
import com.brightcove.player.media.DeliveryType;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveTextureVideoView;

public class MainActivity extends BrightcovePlayer {

    public static final String TAG = MainActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        brightcoveVideoView = (BrightcoveTextureVideoView) findViewById(R.id.brightcove_video_view);
        setContentView(R.layout.activity_main);

        Video video = Video.createVideo("http://media.w3.org/2010/05/sintel/trailer.mp4", DeliveryType.MP4);
        brightcoveVideoView.add(video);
        brightcoveVideoView.start();
    }
}
