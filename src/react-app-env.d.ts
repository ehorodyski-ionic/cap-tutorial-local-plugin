/// <reference types="react-scripts" />

import "@capacitor/core";
import { Plugin } from "@capacitor/core/dist/esm/definitions";
declare module "@capacitor/core" {
  interface AppVersionPlugin extends Plugin {
    getAppVersion(): Promise<{ value: string }>;
  }
  interface PluginRegistry {
    AppVersion: AppVersionPlugin;
    ScreenOrientation: {
      getCurrentOrientation: () => Promise<{ type: ScreenOrientationType }>;
      watchPosition: (
        callback: (type: ScreenOrientationType, err?: any) => void
      ) => CallbackID;
    };
  }
}

// type ScreenOrientationChangeCallback = ({ type: ScreenOrientationType }, err?: any) => void;

//   enum ScreenOrientationType {
//     "PORTRAIT",
//     "LANDSCAPE",
//     "ANY",
//   }
