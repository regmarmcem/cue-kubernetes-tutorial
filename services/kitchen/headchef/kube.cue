package kube

service: headchef: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: headchef: {
	spec: {
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: {
				volumes: [{
					name: "headchef-disk"
					gcePersistentDisk: {
						pdName: "headchef-disk"
						fsType: "ext4"
					}
				}, {
					name: "secret-headchef"
					secret: secretName: "headchef-secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/headchef:v0.2.16"
					volumeMounts: [{
						name:      "headchef-disk"
						mountPath: "/logs"
					}, {
						mountPath: "/sslcerts"
						name:      "secret-headchef"
						readOnly:  true
					}]
					ports: [{
						containerPort: 8080
					}]
					args: [
						"-env=prod",
						"-logdir=/logs",
						"-event-server=events:7788",
					]
					livenessProbe: {
						httpGet: {
							path: "/debug/health"
							port: 8080
						}
						initialDelaySeconds: 40
						periodSeconds:       3
					}
				}]
			}
		}
	}
}
