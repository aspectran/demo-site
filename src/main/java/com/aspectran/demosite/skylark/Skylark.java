package com.aspectran.demosite.skylark;

import com.aspectran.core.activity.Translet;
import com.aspectran.demosite.tts.TextToSpeechBean;

import java.io.IOException;

public class Skylark {

    public void textToSpeech(Translet translet) throws IOException {
        TextToSpeechBean ttsBean = translet.getBean("voice1");
        ttsBean.speak(translet);
    }

}