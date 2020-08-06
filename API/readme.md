# AWS Serverless WebSocket API 

**EN**: This project is a Serverless based API for the purpose of exchanginng directions commands between a user and a robot.


**FR** : Ce projet est une Serverless API qui permet d'échanger des commandes de direction entre un utilisateur et un robot.

## EN: Getting started

### 1. Install Serverless Fremework
the project requires [Serverless Framework](https://www.serverless.com/) to deploy the API in Amazon Web Services


### MacOS/Linux

Run this command in your terminal:

```bash
curl -o- -L https://slss.io/install | bash
```

Then open another terminal window to run `serverless` program.

### [#](https://www.serverless.com/framework/docs/getting-started/#windows)Windows

Install with [Chocolatey](https://chocolatey.org/):

```bash
choco install serverless
```

### [#](https://www.serverless.com/framework/docs/getting-started/#via-npm)using npm

_Note: If you don’t already have [Node](https://nodejs.org/en/download/package-manager/) on your machine, you’ll need to install it first. 

Install the serverless CLI:

```bash
npm install -g serverless
```

### 1. Install AWS CLI
the project also requires AWS command line internface to have access to your AWS account from the terminal.

### Windows

Download the AWS CLI MSI installer for Windows (64-bit) at [https://awscli.amazonaws.com/AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi)

.
    
-   Run the downloaded MSI installer and follow the on-screen instructions. By default, the AWS CLI installs to `C:\Program Files\Amazon\AWSCLIV2`.
    
-   To confirm the installation, open the **Start** menu, search for `cmd` to open a command prompt window, and at the command prompt use the `aws --version` command.
        
```
C:\> aws --version
aws-cli/2.0.23 Python/3.7.4 Windows/10 botocore/2.0.0
```

If Windows is unable to find the program, you might need to close and reopen the command prompt window to refresh the path, or [add the installation directory to your PATH](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html#awscli-install-windows-path) environment variable manually.

### MacOS/Linux

Download the installation file in one of the following ways:

-   Use the `curl` command – The `-o` option specifies the file name that the downloaded package is written to. The options on the following example command write the downloaded file to the current directory with the local name `awscliv2.zip`.
```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

Unzip the installer. If your Linux distribution doesn't have a built-in `unzip` command, use an equivalent to unzip it. The following example command unzips the package and creates a directory named `aws` under the current directory.

  ```
    $ unzip awscliv2.zip
   ```
    
-   Run the install program. The installation command uses a file named `install` in the newly unzipped `aws` directory. By default, the files are all installed to `/usr/local/aws-cli`, and a symbolic link is created in `/usr/local/bin`. The command includes `sudo` to grant write permissions to those directories.
    

```
$ sudo ./aws/install
```

Confirm the installation.

```
$ aws --version
aws-cli/2.0.23 Python/3.7.4 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.0.
```

### AWS CLI Configuration

For general use, the `aws configure` command is the fastest way to set up your AWS CLI installation. When you enter this command, the AWS CLI prompts you for four pieces of information:

-   [Access key ID](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)
    
-   [Secret access key](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)
    
-   [AWS Region](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-region)
    
-   [Output format](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-format)
    

The AWS CLI stores this information in a _profile_ (a collection of settings) named `default` in the `credentials` file. By default, the information in this profile is used when you run an AWS CLI command that doesn't explicitly specify a profile to use. For more information on the `credentials` file, see [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

The following example shows sample values. Replace them with your own values as described in the following sections.

```
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```

## FR : Pour commencer

### 1. Installer le Fremework Serverless
le projet nécessite [Serverless Framework](https://www.serverless.com/) pour déployer l'API dans Amazon Web Services


### MacOS/Linux

Exécutez cette commande dans votre terminal :
```bash
curl -o- -L https://slss.io/install | bash
```

Ensuite, ouvrez une autre fenêtre de terminal pour exécuter le programme "Serverless".

### [#](https://www.serverless.com/framework/docs/getting-started/#windows)Windows

Installer avec [Chocolatey](https://chocolatey.org/) :
```bash
choco install serverless
```

### [#](https://www.serverless.com/framework/docs/getting-started/#via-npm)en utilisant npm

Note : Si vous n'avez pas déjà [Node](https://nodejs.org/en/download/package-manager/) sur votre machine, vous devez d'abord l'installer. 

Installez le CLI sans serveur :
```bash
npm install -g Serverless
```

### 1. Installer AWS CLI
le projet exige également que l'interface de la ligne de commande AWS ait accès à votre compte AWS depuis le terminal.

### Windows

Téléchargez l'installateur AWS CLI MSI pour Windows (64 bits) à l'adresse suivante : [https://awscli.amazonaws.com/AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi)

.
    
- Exécutez le programme d'installation de MSI téléchargé et suivez les instructions à l'écran. Par défaut, le CLI AWS s'installe sur `C:\Program Files\Amazon\AWSCLIV2`.
    
- Pour confirmer l'installation, ouvrez le menu **Démarrer**, cherchez `cmd` pour ouvrir une fenêtre d'invite de commande, et à l'invite de commande, utilisez la commande `aws --version`.
        
```
C:\> aws --version
aws-cli/2.0.23 Python/3.7.4 Windows/10 botocore/2.0.0
```

Si Windows ne trouve pas le programme, vous devrez peut-être fermer et rouvrir la fenêtre d'invite de commande pour rafraîchir le chemin, ou [ajouter le répertoire d'installation à votre variable d'environnement PATH](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html#awscli-install-windows-path) manuellement.

### MacOS/Linux

Téléchargez le fichier d'installation de l'une des façons suivantes :

- Utilisez la commande "curl" - L'option "o" spécifie le nom du fichier dans lequel le paquet téléchargé est écrit. Les options de l'exemple de commande suivant écrivent le fichier téléchargé dans le répertoire courant avec le nom local "awscliv2.zip".
```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

Dézippez l'installateur. Si votre distribution Linux ne dispose pas d'une commande "dézipper" intégrée, utilisez un équivalent pour le dézipper. L'exemple de commande suivant décompresse le paquet et crée un répertoire nommé `aws` sous le répertoire courant.

  ```
    $ unzip awscliv2.zip
   ```
    
- Exécutez le programme d'installation. La commande d'installation utilise un fichier nommé "install" dans le répertoire "aws" récemment décompressé. Par défaut, les fichiers sont tous installés dans `/usr/local/aws-cli`, et un lien symbolique est créé dans `/usr/local/bin`. La commande inclut `sudo` pour accorder les droits d'écriture à ces répertoires.
    

```
$ sudo ./aws/install
```

Confirmez l'installation.

```
$ aws --version
aws-cli/2.0.23 Python/3.7.4 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.0.
```

### Configuration AWS CLI

Pour une utilisation générale, la commande "aws configure" est la manière la plus rapide de configurer votre installation AWS CLI. Lorsque vous entrez cette commande, le CLI AWS vous demande quatre informations :

- [ID de la clé d'accès](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)
    
- [Clé d'accès secrète](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)
    
- [Région AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-region)
    
- [Format de sortie](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-format)
    

L'AWS CLI stocke ces informations dans un _profil_ (une collection de paramètres) nommé "default" dans le fichier "credentials". Par défaut, les informations de ce profil sont utilisées lorsque vous exécutez une commande AWS CLI qui ne spécifie pas explicitement un profil à utiliser. Pour plus d'informations sur le fichier "credentials", voir [Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

L'exemple suivant montre des valeurs d'échantillon. Remplacez-les par vos propres valeurs, comme décrit dans les sections suivantes.

```
$ aws configure
ID de la clé d'accès au SSFE [Aucune] : AKIAIOSFODNN7EXEMPLE
Clé d'accès secrète AWS [Aucune] : wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEY
Nom de la région par défaut [Néant] : us-west-2
Format de sortie par défaut [Aucun] : json
```


## EN: Run and deploy 
To deploy an application go the project directory and  run the following commands:
```bash 
npm install
sls deploy -v
```
after the deploying is finished, AWS will return an endpoint URL for the WebSocket to connect to.


## FR : Exécuter et déployer 
Pour déployer une application, allez dans le répertoire du projet et exécutez les commandes suivantes :
```bash 
npm install
sls deploy -v
```
une fois le déploiement terminé, AWS renvoie une  Endpoint url pour que le WebSocket puisse s'y connecter.
