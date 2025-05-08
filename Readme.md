# Where to get
- You can get the image on [docker.hub](https://hub.docker.com/repository/docker/alyssuuu/flutter/general)

# Reference
This Docker image comes with:
- FVM ✅
- Android SDK ✅
- Flutter command alias that ensures FVM has a flutter version installed ✅

# Usage
You can use this docker image as follows:
```bash
docker run -it alyssuuu/flutter:fvm
```
This will create the docker container that will use the stable version of flutter

If you want to use a specific version of flutter in your container simply use the command:
```bash
docker run -it -e FLUTTER_VERSION="<flutter-version>" alyssuuu/flutter:fvm
```

To use devices and/or emulators is as simple as this:
```bash
# Usb devices
docker run -it --device /dev/bus/usb:/dev/bus/usb alyssuuu/flutter:fvm

# Emulators
docker run -it --device /dev/kvm:/dev/kvm alyssuuu/flutter:fvm
```

Mapping the app data to the container:
```bash
docker run -it -v <source>:/app alyssuuu/flutter:fvm
```

You can also use this image with a docker file:
```yml
services:
  app:
    container_name: my-app
    image: alyssuuu/flutter:fvm
    restart: on-failure
    volumes:
      - .:/app # Mounting the app data do my current directory
      - ~/.fvm:/sdk/fvm # Makes the FVM flutter versions visible to IDEs
    environment:
        FLUTTER_VERSION: "3.27.4"
    devices:
      - /dev/bus/usb:/dev/bus/usb
      - /dev/kvm:/dev/kvm
    privileged: true
    command: ["tail", "-f", "/dev/null"] # Ensures the container keeps running
    
volumes:
  app-data:
  fvm-sdk:
```