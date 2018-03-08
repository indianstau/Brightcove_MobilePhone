package com.brightcove.live;

//import android.support.v7.app.AppCompatActivity;
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

        Video video = Video.createVideo("https://tvbs-alive1.akamaized.net/c3f920d0a52946c287327174357a4fb1/ap-southeast-1/4862438529001/playlist.m3u8?hdnts=exp=1507617642~acl=/*~hmac=ca39204cb58c8ce5572e4eaf4a882b523c38042ad7db76f64a30a432d9ce3f41", DeliveryType.HLS);
        video.getProperties().put(Video.Fields.PUBLISHER_ID, "4862438529001");
        brightcoveVideoView.add(video);
        brightcoveVideoView.start();
    }
}
