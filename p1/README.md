# K3S:

K3s est une distribution légère de Kubernetes conçue pour les environnements de production de petite à moyenne taille, les environnements de développement, les clusters edge, et les environnements de test. K3s est conçu pour être plus simple à installer et à gérer que Kubernetes standard tout en conservant les fonctionnalités principales.


## À quoi sert K3s ?

K3s permet de déployer, gérer et faire évoluer des applications containerisées de manière efficace. Il est particulièrement utile dans les scénarios suivants :

- Edge Computing : Les ressources limitées en périphérie nécessitent une solution Kubernetes légère.
- Développement et Test : Pour les développeurs qui ont besoin de clusters Kubernetes facilement configurables pour tester leurs applications.
- Petites Infrastructures : Idéal pour les petites entreprises ou les projets qui n'ont pas besoin d'un cluster Kubernetes complet et lourd.
- IoT : K3s est parfait pour les dispositifs IoT qui nécessitent une orchestration containerisée.


### Avantages de K3s

- Légèreté : K3s a une empreinte mémoire et CPU plus petite par rapport à Kubernetes standard. Il est conçu pour fonctionner dans des environnements à faibles ressources.
- Simplicité d'installation : Une seule commande permet d'installer un cluster K3s, simplifiant ainsi grandement le processus de mise en place.
- Complet : K3s inclut toutes les fonctionnalités essentielles de Kubernetes tout en supprimant les composants non indispensables pour des scénarios légers.
- Optimisé pour les petites instances : Fonctionne bien sur des matériels modestes comme les Raspberry Pi.
- Sécurisé : K3s intègre des composants comme Traefik pour le reverse proxy et Flannel pour le réseau, configurés par défaut avec des pratiques de sécurité.


## Concepts de base

### Node
Un node dans K3s, comme dans Kubernetes, est une machine physique ou virtuelle qui fait partie du cluster Kubernetes. Chaque node exécute les pods et les services nécessaires pour faire tourner les applications containerisées.

### Server Node :
Responsable de la gestion de l'état global du cluster, des planifications, des décisions de scaling, etc.
Le serveur K3s joue le rôle de control plane dans Kubernetes. Il gère l'état du cluster, l'API Kubernetes, le scheduling des workloads, etc. Un serveur K3s peut également exécuter des workloads si nécessaire.

### Server Worker Node :
Exécute les applications containerisées déployées sur le cluster.
Il est responsable de l'exécution des workloads (containers) sur le cluster. Les agents se connectent aux serveurs K3s pour obtenir leurs instructions et états de gestion.


## Conclusion
K3s offre une version simplifiée et allégée de Kubernetes, ce qui le rend idéal pour les environnements où les ressources sont limitées ou où une installation simplifiée est souhaitée. Il conserve les fonctionnalités essentielles de Kubernetes tout en étant facile à installer et à gérer. Le modèle serveur-agent facilite la gestion et le déploiement des applications containerisées dans divers scénarios allant des développements légers aux applications edge et IoT.
