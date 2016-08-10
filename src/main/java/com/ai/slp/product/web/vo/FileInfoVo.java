package com.ai.slp.product.web.vo;

/**
 * 上传文件返回信息
 * Created by jackieliu on 16/6/22.
 */
public class FileInfoVo {
    /**
     * 文件标识
     */
    private String vfsId;
    /**
     * 文件类型,即文件扩展名
     */
    private String fileType;

    public String getVfsId() {
        return vfsId;
    }

    public void setVfsId(String vfsId) {
        this.vfsId = vfsId;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
}
