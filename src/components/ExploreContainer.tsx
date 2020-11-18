import React, { useEffect, useState } from 'react';
import { Plugins } from '@capacitor/core';
import './ExploreContainer.css';

interface ContainerProps { }

const ExploreContainer: React.FC<ContainerProps> = () => {
  const [appVersion, setAppVersion] = useState<string>('Fetching...');

  useEffect(() => {
    const init = async () => {
      const { AppVersion } = Plugins;
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
