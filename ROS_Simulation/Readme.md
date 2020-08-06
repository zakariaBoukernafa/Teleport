# Overview / Aperçu général

**EN**:
This is a ROS package for the purpose of controlling a robot model in a simulator in realtime via a Websocket.

**EN**:
The package will contain: 
* Workspace of this project (config build files, robot model, etc)
* An executable Python script handles: 
    * Websocket connection establishment with the API Gateway as well as data (directions) reception.
    * ROS components for sending data (velocity) to the robot model in the simulator.

**FR**: 
Il s'agit d'un paquet ROS destiné à contrôler un modèle de robot dans un simulateur en temps réel via un Websocket.

**FR**: 
Le paquet contiendra :
* Le workspace du projet (fichiers de configuration, modèle de robot, etc.)
* Ce script Python exécutable gère:
    * L'établissement d'une connexion Websocket avec la passerelle API ainsi que la réception des données (directions).
    *  Les composants ROS pour l'envoi de données (vitesse) au modèle de robot dans le simulateur.

## Get started / Guide de Démarrage
**EN**: 
To test the simulation, the following requirments are needed: 

**FR** : 
Pour tester la simulation, les conditions suivantes sont nécessaires :

1) Installed: [Linux Ubuntu 18.04 LTS](https://ubuntu.com/download/desktop) (installed on your machine or on a VM)
2) Installed: [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu)
3) Installed: [Python 2.x](http://wiki.ros.org/melodic/Installation/Ubuntu)
4) Installed: [Catkin](https://wiki.ros.org/catkin#Installing_catkin)

### Creating the Workspace / Creation du Workspace
1.  Creating and Initializing a Workspace Folder / Création et initialisation du dossier du Workspace 
```bash
#Init
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws/src
$ catkin_init_workspace

#Build
$ cd ~/catkin_ws/
$ catkin_make
```
2. Import the setting file associated with the catkin build system / Importer le fichier de paramétrage associé au système de construction du chaton

```bash
$ source ~/catkin_ws/devel/setup.bash
```

3. Robot package installation / Installation du paquet du robot

* Download repo: [Robot package](https://github.com/mario-serna/pioneer_p3dx_model.git)
* Installation: 
```
$ cd <catkin_ws>/src
$ git clone https://github.com/mario-serna/pioneer_p3dx_model.git
$ cd ..
$ catkin_make
```

4.  Python script
* Download: [test_mover.py](https://github.com/zakariaBoukernafa/Teleport/blob/master/ROS_Simulation/test_mover.py)
* Paste it inside: 
```bash
$ ~/catkin_ws/src
```

## Usage / Utilisation

* **EN**: Launching ROS + Spawning P3dx robot model in Gazebo

* **FR**:  Execution de ROS + Invocation du modèle P3dx dans Gazebo
```bash
$ roslaunch p3dx_gazebo gazebo.launch
```
* **EN**: 
in another terminal execute the script 

* **FR**:  Dans un autre terminal, executez le script
```bash
$ ~/catkin_ws/src: python test_mover.py
```

## Simulation script insight / Aperçu du script de simulation

* **EN**: You need to import rospy if you are writing a ROS Node.

* **EN**: You need to impoty websocket if you want to work with websocket.

* **FR**: Vous devez importer rospy si vous créez un nœud ROS.

* **FR**: Vous devez impoter websocket si vous voulez travailler avec websocket.
```python
#ros imports
import rospy
from rospy.core import is_shutdown

#websoket imports
from websocket import create_connection
```
**EN**:  rospy.Publisher("p3dx/cmd_vel", Twist, queue_size=10) declares that your node is publishing to the p3dx/cmd_vel topic using the message type Twist.

**EN**:  This is a very important as it tells rospy the name of the node (test_mover). Until rospy has this information, it cannot start communicating with the ROS Master.

**FR** : rospy.Publisher("p3dx/cmd_vel", Twist, queue_size=10) déclare que votre Noeud publie dans le topic p3dx/cmd_vel en utilisant le type de message Twist.

**FR** :  Ceci est très important car il indique à rospy le nom du nœud (test_mover). Tant que rospy ne dispose pas de cette information, il ne peut pas commencer à communiquer avec le ROS Master.

```python
#ROS components initialization
rospy.init_node('test_mover', anonymous=True)
pubToTopic = rospy.Publisher("p3dx/cmd_vel", Twist, queue_size=10)
```
## Configuration / Configuration
**EN**: You will need to put your own endpoint link to the Websocket inside the create_connection().

```python
#Websocket connection establishment
ws = create_connection("PUT_YOUR_ENDPOINT_LINK_TO_THE_WEBSOCKET_API_HERE")
```
**EN**: Parsing the received data and extract the 'direction' and 'robotID'. 

**FR**: Analyse des données reçues et extraction de la "direction" et du "robotID".

```python
msgReceived =  ws.recv()
stringToJson = json.loads(msgReceived)
direction = stringToJson['direction']
robotID = stringToJson['robotID']
```
**EN**: Twist type expresses velocity in a free space broken into its 'linear' and 'angular' parts.

**EN**: pubToTopic.publish(vel_msg) publishes the Twist message holding the velocities (angular and/or linear) to p3dx/cmd_vel topic.

**FR** : Le type Twist exprime la vitesse dans un espace libre divisé en parties "linéaire" et "angulaire".

**FR** : pubToTopic.publish(vel_msg) publie le message Twist contenant les vitesses (angulaires et/ou linéaires) au topic p3dx/cmd_vel.

```python
vel_msg = Twist()
vel_msg.linear.x = abs(speed)
vel_msg.angular.z = abs(angular_speed)
pubToTopic.publish(vel_msg)
```
