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
    return window.screen.orientation.lock(orientation);
  }

  async unlock(): Promise<void> {
    return window.screen.orientation.unlock();
  }
}
