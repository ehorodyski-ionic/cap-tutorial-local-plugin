import '@capacitor/core';

declare module '@capacitor/core' {
  interface ScreenOrientationPlugin {
    orientation(): Promise<{ type: OrientationType; angle: number }>;
    lock(options: { orientation: OrientationLockType }): Promise<void>;
    unlock(): Promise<void>;
  }

  interface PluginRegistry {
    ScreenOrientation: ScreenOrientationPlugin;
  }
}
