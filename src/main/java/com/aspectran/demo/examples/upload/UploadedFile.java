package com.aspectran.demo.examples.upload;

import com.aspectran.core.component.bean.annotation.NonSerializable;

/**
 * <p>Created: 2018. 7. 9.</p>
 */
public class UploadedFile {

    private String fileName;

    private String fileSize;

    private String fileType;

    private byte[] bytes;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileSize() {
        return fileSize;
    }

    public void setFileSize(String fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    @NonSerializable
    public byte[] getBytes() {
        return bytes;
    }

    public void setBytes(byte[] bytes) {
        this.bytes = bytes;
    }
}
