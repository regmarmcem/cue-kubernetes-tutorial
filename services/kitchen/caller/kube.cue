package kube

service: caller: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: caller: {
	spec: {
		replicas: 3
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: {
				volumes: [{
					name: "ssd-caller"
					gcePersistentDisk: {
						// This disk must already exist.
						pdName: "ssd-caller"
						fsType: "ext4"
					}
				}, {
					name: "secret-caller"
					secret: secretName: "caller-secrets"
				}, {
					name: "secret-ssh-key"
					secret: secretName: "secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/caller:v0.20.14"
					volumeMounts: [{
						name:      "ssd-caller"
						mountPath: "/logs"
					}, {
						mountPath: "/etc/certs"
						name:      "secret-caller"
						readOnly:  true
					}, {
						mountPath: "/sslcerts"
						name:      "secret-ssh-key"
						readOnly:  true
					}]
					ports: [{
						containerPort: 8080
					}]
					args: [
						"-env=prod",
						"-key=/etc/certs/client.key",
						"-cert=/etc/certs/client.pem",
						"-ca=/etc/certs/servfx.ca",
						"-ssh-tunnel-key=/sslcerts/tunnel-private.pem",
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
