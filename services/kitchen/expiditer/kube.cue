package kube

service: expiditer: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: expiditer: {
	spec: {
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: {
				volumes: [{
					name: "expiditer-disk"
					gcePersistentDisk: {
						pdName: "expiditer-disk"
						fsType: "ext4"
					}
				}, {
					name: "secret-expiditer"
					secret: secretName: "expiditer-secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/expiditer:v0.5.34"
					volumeMounts: [{
						name:      "expiditer-disk"
						mountPath: "/logs"
					}, {
						mountPath: "/etc/certs"
						name:      "secret-expiditer"
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
