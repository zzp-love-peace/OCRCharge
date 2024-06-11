import common from '@ohos.app.ability.common';
import picker from '@ohos.file.picker';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import wantConstant from '@ohos.ability.wantConstant';
import StringUtil from '../utils/StringUtil';
import { MediaBean } from './MediaBean';



/**
 * 多媒体辅助类
 */
export class MediaHelper {
  private readonly TAG: string = 'MediaHelper';
  private mContext: common.Context;

  constructor(context: common.Context) {
    this.mContext = context;
  }

  /**
   * 选择图片
   */
  public selectPicture(): Promise<MediaBean> {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      return photoPicker.select(photoSelectOptions)
        .then((photoSelectResult) => {

          if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
            let filePath = photoSelectResult.photoUris[0];
            return filePath;
          }

        }).catch((err) => {
          return err;
        }).then(async (filePath) => {
          const mediaBean = await this.buildMediaBean(filePath);
          return mediaBean;
        });
    } catch (err) {
      return Promise.reject(err);
    }
  }
  /**
   * 选择文件
   */
  public selectFile(): Promise<MediaBean> {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      return documentPicker.select(documentSelectOptions)
        .then((documentSelectResult) => {

          if (documentSelectResult && documentSelectResult.length > 0) {
            let filePath = documentSelectResult[0];
            return filePath;
          }

        }).catch((err) => {
          return err;
        }).then(async (filePath) => {
          const mediaBean = await this.buildMediaBean(filePath);
          return mediaBean;

        });
    } catch (err) {
      return Promise.reject(err);
    }
  }

  /**
   * 拍照
   */
  public async takePhoto(context: common.UIAbilityContext): Promise<MediaBean> {

    let want = {
      'uri': '',
      'action': wantConstant.Action.ACTION_IMAGE_CAPTURE,
      // 'parameters': {},
      parameters: {
        callBundleName: "com.zzp.ocrcharge"
      }
    };
    return context.startAbilityForResult(want)
      .then((result) => {
        if (result.resultCode === 0 && result.want && StringUtil.isNotNullOrEmpty(result.want.uri)) {
          //拍照成功
          return result.want.uri;
        }
      }).catch((error) => {
        return error;
      }).then(async (uri: string) => {
        const mediaBean = await this.buildMediaBean(uri);
        return mediaBean;
      });
  }
  /**
   * 封装多媒体实体类
   *
   * @param uri 文件路径
   */
  private async buildMediaBean(uri: string): Promise<MediaBean> {

    if (StringUtil.isNullOrEmpty(uri)) {
      return null;
    }

    const mediaBean: MediaBean = new MediaBean();
    mediaBean.localUrl = uri;
    await this.appendFileInfoToMediaBean(mediaBean, uri);
    return mediaBean;
  }
  /**
   * 通过Uri查找所选文件信息，插入到MediaBean中
   * @param mediaBean
   * @param uri
   */
  private async appendFileInfoToMediaBean(mediaBean: MediaBean, uri: string) {

    if (StringUtil.isNullOrEmpty(uri)) {
      return;
    }
    let fileList: Array<mediaLibrary.FileAsset> = [];

    const parts: string[] = uri.split('/');
    const id: string = parts.length > 0 ? parts[parts.length - 1] : '-1';

    try {

      let media = mediaLibrary.getMediaLibrary(this.mContext);
      let mediaFetchOptions: mediaLibrary.MediaFetchOptions = {
        selections: mediaLibrary.FileKey.ID + '= ?',
        selectionArgs: [id],
        uri: uri
      };
      let fetchFileResult = await media.getFileAssets(mediaFetchOptions);
      fileList = await fetchFileResult.getAllObject();
      fetchFileResult.close();
      await media.release();

    } catch (e) {
    }

    if (fileList && fileList.length > 0) {

      let fileInfoObj = fileList[0];
      mediaBean.fileName = fileInfoObj.displayName;
      mediaBean.fileSize = fileInfoObj.size;
      mediaBean.fileType = fileInfoObj.mimeType;

    }
  }
}