import data_preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import Logger from './Logger';

const OCR_STORE: string = 'OCRAppStore';

export class PreferencesUtil {
  private myPreferences

  public initPreferences(context: common.UIAbilityContext) {
    this.myPreferences = data_preferences.getPreferences(context, OCR_STORE)
  }

  public get<R = any>(key: string, defaultValue: R, callback: ((value: R) => void)) {
    this.myPreferences.then((res) => {
      res.get(key, defaultValue).then((value) => {
        callback(value)
      }).catch((err: Error) => {
        Logger.error('LoginPage', err);
      });
    })
  }

  public put(key: string, value: any) {
    this.myPreferences.then((res) => {
      res.put(key, value).then(() => {
        res.flush();
      }).catch((err: Error) => {
        Logger.error('LoginPage', err);
      });
    })
  }

}

export default new PreferencesUtil()