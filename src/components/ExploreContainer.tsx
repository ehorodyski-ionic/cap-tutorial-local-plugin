import React, { useEffect, useState } from 'react';
import { AppVersionPlugin, Plugins, registerWebPlugin, WebPlugin } from '@capacitor/core';
import './ExploreContainer.css';

export class AppVersionWeb extends WebPlugin implements AppVersionPlugin {
  constructor() {
    super({
      name: 'AppVersion',
      platforms: ['web']
    });
  }

  async getAppVersion() {
    return Promise.resolve({ value: '1.0.0' });
  }
}

const AppVersionWeb_Proxy = new AppVersionWeb();
registerWebPlugin(AppVersionWeb_Proxy);


const ExploreContainer: React.FC = () => {
  const [appVersion, setAppVersion] = useState<string>('Fetching...');

  useEffect(() => {
    const init = async () => {
      const { AppVersion, Device } = Plugins;
      const data = await Device.getInfo();
      console.log(data);

      const { value } = await AppVersion.getAppVersion();
      setAppVersion(value);
    };
    init();
  }, []);

  return (
    <div className="container">
      <strong>Ready to see your app version?</strong>
      <p>{appVersion}</p>
    </div>
  );
};

export default ExploreContainer;
