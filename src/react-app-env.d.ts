/// <reference types="react-scripts" />

import "@capacitor/core";
declare module "@capacitor/core" {
  interface PluginRegistry {
    AppVersion: {
      getAppVersion: () => Promise<{ value: string }>;
    };
  }
}
