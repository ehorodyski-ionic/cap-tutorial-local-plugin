import { Plugins } from '@capacitor/core';
import {
  IonButton,
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonTitle,
  IonToolbar,
} from '@ionic/react';
import React, { useEffect, useState } from 'react';
import { checkmarkCircle, phoneLandscape } from 'ionicons/icons';
import './Home.css';

const Home: React.FC = () => {
  const [currentOrientation, setCurrentOrientation] = useState<string>(
    'Fetching...',
  );

  const getOrientation = async () => {
    const { ScreenOrientation } = Plugins;
    const { type } = await ScreenOrientation.orientation();
    setCurrentOrientation(type);
  };

  const lockOrientation = async () => {
    const { ScreenOrientation } = Plugins;
    await ScreenOrientation.lock({ orientation: 'landscape-primary' });
  };

  const unlockOrientation = async () => {
    const { ScreenOrientation } = Plugins;
    await ScreenOrientation.unlock();
  };

  window.addEventListener(
    'orientationchange',
    async () => await getOrientation(),
  );

  useEffect(() => {
    (async () => {
      await getOrientation();
    })();
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Add a New Signature</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        {currentOrientation.includes('portrait') && (
          <div className="incorrect-orientation">
            <p>
              Please turn your device to landscape mode so we can best capture
              your signature.
            </p>
            <IonButton onClick={() => lockOrientation()}>
              <IonIcon icon={phoneLandscape} />
              Rotate My Device
            </IonButton>
          </div>
        )}
        {currentOrientation.includes('landscape') && (
          <div className="ion-padding esign">
            <span>Please add your signature below:</span>
            <div className="esign-pad" />
            <IonButton expand="full" onClick={() => unlockOrientation()}>
              <IonIcon icon={checkmarkCircle} />
              Add Signature
            </IonButton>
          </div>
        )}
      </IonContent>
    </IonPage>
  );
};

export default Home;
