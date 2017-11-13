# Docker JetBrains YouTrack

__Simple run__

```bash
docker run -d -p 80:8080 bmxmale/docker-youtrack:2017.3.37517
```

__Example docker stack file__

```bash
version: '3'
services:
  app:
    image: bmxmale/docker-youtrack:2017.3.37517
    volumes:
     - ./data:/opt/youtrack/data/
     - ./backups:/opt/youtrack/backups
     - ./logs:/opt/youtrack/logs
    deploy:
      labels:
        - "traefik.backend=YouTrack"
        - "traefik.port=8080"
        - "traefik.frontend.rule=Host:youtrack.udviklet.dk"
        - "traefik.docker.network=MAGENTO_network"
      mode: global
      placement:
        constraints: [node.role == manager]
networks:
    default:
        external:
            name: MAGENTO_network

```

Before stack start you need to create data/backups/logs dir and grant write permission. In default YouTrack run as user with uid 2000.