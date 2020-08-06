# Teleport
**EN**: Teleport is a Flutter mobile app made to control a telepresence robot remotly using [Google Firebase](https://firebase.google.com/), [Amazon Web Services](aws.amazon.com/) and Agora.io.

**FR**: Teleport est une application mobile Flutter conçue pour contrôler un robot de téléprésence à distance en utilisant [Google Firebase](https://firebase.google.com/), [Amazon Web Services](aws.amazon.com/) et Agora.io.
## Get started
###  Setting up your environment


####  Getting the Flutter Framework

 Flutter Framework requires Dart SDK to run but **As of Flutter 1.20, the [Flutter SDK](https://flutter.dev/docs/get-started/install) includes the Dart SDK.** So if you have Flutter installed, you might not need to explicitly download the Dart SDK.


#### Windows:

Clone the `stable` branch from the Flutter repository:
```
git clone https://github.com/flutter/flutter.git -b stable
```

If you wish to run Flutter commands in the regular Windows console, take these steps to add Flutter to the `PATH` environment variable:

-   From the Start search bar, enter ‘env’ and select **Edit environment variables for your account**.
-   Under **User variables** check if there is an entry called **Path**:
    -   If the entry exists, append the full path to `flutter\bin` using `;` as a separator from existing values.
    -   If the entry doesn’t exist, create a new user variable named `Path` with the full path to `flutter\bin` as its value.

You have to close and reopen any existing console windows for these changes to take effect.


####  Linux:
The easiest way to install Flutter on Linux is by using snapd. For more information, see [Installing snapd](https://snapcraft.io/docs/installing-snapd).

Once you have snapd, you can [install Flutter using the Snap Store](https://snapcraft.io/flutter), or at the command line:
```
$ sudo snap install flutter --classic
```

## FR: Pour commencer

### Mise en place de votre environnement

####  Obtenir le framework Flutter


Flutter Framework nécessite le SDK Dart pour fonctionner mais **A partir de Flutter 1.20, le [SDK Flutter](https://flutter.dev/docs/get-started/install) inclut le SDK Dart.** Donc si vous avez installé Flutter, vous n'avez peut-être pas besoin de télécharger explicitement le SDK Dart.

#### Windows :

Clone la branche "stable" du dépôt Flutter :
```
git clone https://github.com/flutter/flutter.git -b stable
```

Si vous souhaitez exécuter les commandes Flutter dans la console Windows normale, suivez ces étapes pour ajouter Flutter à la variable d'environnement "PATH" :

- Dans la barre de recherche, entrez "env" et sélectionnez **Editer les variables d'environnement pour votre compte**.
- Sous **Variables d'utilisateur**, vérifiez s'il y a une entrée appelée **Chemin** :
    - Si l'entrée existe, ajoutez le chemin complet à "flutter\bin" en utilisant ";` comme séparateur des valeurs existantes.
    - Si l'entrée n'existe pas, créez une nouvelle variable utilisateur appelée "Chemin" avec le chemin complet vers "flutter\bin" comme valeur.

Vous devez fermer et rouvrir toutes les fenêtres de console existantes pour que ces changements prennent effet.

#### Linux :
La façon la plus simple d'installer Flutter sur Linux est d'utiliser snapd. Pour plus d'informations, voir [Installer snapd](https://snapcraft.io/docs/installing-snapd).

Une fois que vous avez installé snapd, vous pouvez [installer Flutter en utilisant le Snap Store](https://snapcraft.io/flutter), ou en ligne de commande :
```
$ sudo snap install flutter --classic
```



### EN: Android setup
1.  Download and install [Android Studio](https://developer.android.com/studio).
2.  Start Android Studio, and go through the ‘Android Studio Setup Wizard’. This installs the latest Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.

#### Set up your Android device:

To prepare to run and test your Flutter app on an Android device, you need an Android device running Android 4.1 (API level 16) or higher.

1.  Enable **Developer options** and **USB debugging** on your device. Detailed instructions are available in the [Android documentation](https://developer.android.com/studio/debug/dev-options).
2.  Windows-only: Install the [Google USB Driver](https://developer.android.com/studio/run/win-usb).
3.  Using a USB cable, plug your phone into your computer. If prompted on your device, authorize your computer to access your device.
4.  In the terminal, run the `flutter devices` command to verify that Flutter recognizes your connected Android device. By default, Flutter uses the version of the Android SDK where your `adb` tool is based. If you want Flutter to use a different installation of the Android SDK, you must set the `ANDROID_SDK_ROOT` environment variable to that installation directory.

### FR: Installation de l'Android: 
1.  Télécharger et installer [Android Studio](https://developer.android.com/studio)
2.  Démarrez Android Studio, et passez par l'assistant d'installation d'Android Studio. Celui-ci installe le dernier SDK Android, les outils en ligne de commande du SDK Android et les outils de compilation du SDK Android, qui sont requis par Flutter lors du développement pour Android.

#### Configurez votre appareil Android :

Pour vous préparer à exécuter et à tester votre application Flutter sur un appareil Android, vous avez besoin d'un appareil Android fonctionnant sous Android 4.1 (API niveau 16) ou supérieur.

1.  Activez les **options de développement** et le **débogage USB** sur votre appareil. Des instructions détaillées sont disponibles dans la [documentation Android](https://developer.android.com/studio/debug/dev-options).
2.  Windows uniquement : Installez le pilote [USB Google](https://developer.android.com/studio/run/win-usb).
3.  A l'aide d'un câble USB, branchez votre téléphone à votre ordinateur. Si votre appareil vous y invite, autorisez votre ordinateur à accéder à votre appareil.
4.  Dans le terminal, lancez la commande "Flutter devices" pour vérifier que Flutter reconnaît votre appareil Android connecté. Par défaut, Flutter utilise la version du SDK Android sur laquelle est basé votre outil "adb". Si vous voulez que Flutter utilise une installation différente du SDK Android, vous devez définir la variable d'environnement `ANDROID_SDK_ROOT` dans ce répertoire d'installation.


## EN: Configuration

 before running the code, you have to provide some basic configurations to start the project


### Setup Flutter Firebase integration

Check out the [documentation](https://codelabs.developers.google.com/codelabs/flutter-firebase/#5) to setup Flutter Firebase integration.

##### For Android

In `android/app` folder add your `google-service.json`.

### Agora SDK AppID Configuration

To build and run the sample application, first obtain an app ID:

1.  Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the sign-up process, you are redirected to the dashboard.
2.  Navigate in the dashboard tree on the left to **Projects** > **Project List**.
3.  Copy the app ID that you obtain from the dashboard into a text file.
Open the [settings.dart](https://github.com/zakariaBoukernafa/Teleport/blob/master/lib/modes/agora/utils/settings.dart) file and add the app ID.

    ````
      const APP_ID = "";

### API Gateway WebSocket endpoint Configuration

after deploying the WebSocket into AWS or any other cloud provider,go to 
[aws.dart](https://github.com/zakariaBoukernafa/Teleport/blob/master/lib/services/aws.dart) and add the WebSocket endpoint url.
````
final awsChannel = IOWebSocketChannel.connect("");
````


## FR : Configuration

 avant d'exécuter le code, vous devez fournir quelques configurations de base pour démarrer le projet


### Configuration de l'intégration de Firebase Flutter

Consultez la [documentation](https://codelabs.developers.google.com/codelabs/flutter-firebase/#5) pour configurer l'intégration de Flutter Firebase.

##### Pour Android

Dans le dossier `android/app`, ajoutez votre `google-service.json`.

### Agora SDK AppID Configuration

Pour créer et exécuter l'application type, il faut d'abord obtenir un identifiant d'application :

1.  Créez un compte de développeur sur [agora.io](https://dashboard.agora.io/signin/). Une fois le processus d'inscription terminé, vous êtes redirigé vers le tableau de bord.
2.  Naviguez dans l'arborescence du tableau de bord sur la gauche vers **Projets** > **Liste des projets**.
3.  Copiez l'identifiant de l'application que vous obtenez du tableau de bord dans un fichier texte.
Ouvrez le fichier [settings.dart](https://github.com/zakariaBoukernafa/Teleport/blob/master/lib/modes/agora/utils/settings.dart) et ajoutez l'ID de l'application.

    ````
      const APP_ID = "" ;

### Configuration du API Gateway Endpoint  WebSocket

après avoir déployé le WebSocket dans AWS ou dans un autre fournisseur de cloud , allez à 
[aws.dart](https://github.com/zakariaBoukernafa/Teleport/blob/master/lib/services/aws.dart) et ajoutez l'url du Endpoint WebSocket.
````
final awsChannel = IOWebSocketChannel.connect("") ;
````


## EN: Run the project 
-   Open this project folder with Terminal/CMD and run `flutter packages get`
- Run `flutter run` to build and run the debug app on your emulator/phone

## FR: Exécuter le projet 
- Ouvrez ce dossier de projet avec Terminal/CMD et lancez "Flutter packages get".
- Exécutez "flutter run" pour construire et exécuter l'application de débogage sur votre émulateur/téléphone
