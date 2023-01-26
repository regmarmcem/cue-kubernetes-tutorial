package kube

service: pastrychef: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: pastrychef: {
	spec: {
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: {
				volumes: [{
					name: "pastrychef-disk"
					gcePersistentDisk: {
						pdName: "pastrychef-disk"
						fsType: "ext4"
					}
				}, {
					name: "secret-ssh-key"
					secret: secretName: "secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/pastrychef:v0.1.15"
					volumeMounts: [{
						name:      "pastrychef-disk"
						mountPath: "/logs"
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
						"-reconnect-delay=1m",
						"-etcd=etcd:2379",
						"-recovery-overlap=10000",
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
