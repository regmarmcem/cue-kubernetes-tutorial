package kube

service: dishwasher: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: dishwasher: {
	spec: {
		replicas: 5
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: {
				volumes: [{
					name: "dishwasher-disk"
					gcePersistentDisk: {
						pdName: "dishwasher-disk"
						fsType: "ext4"
					}
				}, {
					name: "secret-dishwasher"
					secret: secretName: "dishwasher-secrets"
				}, {
					name: "secret-ssh-key"
					secret: secretName: "dishwasher-secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/dishwasher:v0.2.13"
					volumeMounts: [{
						name:      "dishwasher-disk"
						mountPath: "/logs"
					}, {
						mountPath: "/sslcerts"
						name:      "secret-dishwasher"
						readOnly:  true
					}, {
						mountPath: "/etc/certs"
						name:      "secret-ssh-key"
						readOnly:  true
					}]
					ports: [{
						containerPort: 8080
					}]
					args: [
						"-env=prod",
						"-ssh-tunnel-key=/etc/certs/tunnel-private.pem",
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
