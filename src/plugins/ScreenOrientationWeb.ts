import { ScreenOrientationPlugin, WebPlugin } from '@capacitor/core';

export class ScreenOrientationWeb
  extends WebPlugin
  implements ScreenOrientationPlugin {
  constructor() {
    super({
      name: 'ScreenOrientation',
      platforms: ['web'],
    });
  }

  async orientation(): Promise<{ type: OrientationType; angle: number }> {
    return window.screen.orientation;
  }

  async lock(orientation: OrientationLockType): Promise<void> {
    try {
      await window.screen.orientation.lock(orientation);
      return;
    } catch (error) {
      // Suppress any errors if we can't lock on the web.
      return;
    }
  }

  async unlock(): Promise<void> {
    return window.screen.orientation.unlock();
  }
}
