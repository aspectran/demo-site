package com.aspectran.demo.examples.upload;

import com.aspectran.core.activity.Translet;
import com.aspectran.core.component.bean.annotation.Configuration;
import com.aspectran.core.component.bean.annotation.RequestAsDelete;
import com.aspectran.core.component.bean.annotation.RequestAsGet;
import com.aspectran.core.component.bean.annotation.RequestAsPost;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * <p>Created: 2018. 7. 9.</p>
 */
@Configuration(namespace = "/examples/file-upload")
public class SimpleFileUploadAction {

    private Map<String, UploadedFile> uploadedFiles = new LinkedHashMap<>();

    @RequestAsPost("/file")
    public void upload(Translet translet) {

    }

    @RequestAsGet("/file/${fileKey}")
    public void get(Translet translet) {

    }

    @RequestAsDelete("/file/${fileKey}")
    public void delete(Translet translet) {

    }

}
