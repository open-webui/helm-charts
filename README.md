# Open WebUI Helm Charts
Helm charts for the [Open WebUI](https://github.com/open-webui/open-webui) application.

## Downloading the Chart
The charts are hosted at https://helm.openwebui.com. You can add the Helm repo with:
```
helm repo add open-webui https://helm.openwebui.com/
``` 

## Dev Builds
Open WebUI dev images can be tested with the stable chart by overriding the image tag:
```
helm upgrade --install open-webui open-webui/open-webui --set image.tag=dev
```

Dev chart prereleases are published automatically after dev images are available. Install them with:
```
helm repo update
helm upgrade --install open-webui open-webui/open-webui --devel
```
