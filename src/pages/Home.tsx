import { Plugins } from '@capacitor/core';
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonTitle,
  IonToolbar,
} from '@ionic/react';
import React, { useEffect, useState } from 'react';
import { lockClosedOutline, lockOpenOutline } from 'ionicons/icons';
import './Home.css';

const Home: React.FC = () => {
  const [orientation, setOrientation] = useState<string>('Fetching...');
  const [isLocked, setIsLocked] = useState<boolean>(false);

  const getOrientation = async () => {
    const { ScreenOrientation } = Plugins;
    return await ScreenOrientation.orientation();
  };

  const toggleOrientationLock = async () => {
    const { ScreenOrientation } = Plugins;
    if (isLocked) {
      await ScreenOrientation.unlock();
      setIsLocked(false);
    } else {
      await ScreenOrientation.lock({ orientation: 'landscape-primary' });
      setIsLocked(true);
    }
  };

  window.addEventListener('orientationchange', async () => {
    const { type } = await getOrientation();
    setOrientation(type);
  });

  useEffect(() => {
    const init = async () => {
      const { type } = await getOrientation();
      setOrientation(type);
    };
    init();
  }, []);

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>eSignature</IonTitle>
          <IonButtons slot="end">
            <IonButton onClick={() => toggleOrientationLock()}>
              <IonIcon icon={isLocked ? lockOpenOutline : lockClosedOutline} />
              {isLocked ? 'Unlock' : 'Lock'}
            </IonButton>
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        {orientation.includes('portrait') && (
          <div className="incorrect-orientation">
            Please {isLocked && 'unlock rotation and '}
            turn your device to landscape mode in order to accurately capture
            your signature.
          </div>
        )}
        {orientation.includes('landscape') && (
          <div className="ion-padding esign">
            <span>Please add your signature below:</span>
            <div className="esign-pad" />
            <IonButton expand="full">Add Signature</IonButton>
          </div>
        )}
      </IonContent>
    </IonPage>
  );
};

export default Home;
