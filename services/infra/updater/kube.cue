package kube

service: updater: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "updater"
		labels: {
			app:       "updater"
			domain:    "prod"
			component: "infra"
		}
	}
	spec: {
		ports: [{
			port:       8080
			protocol:   "TCP"
			targetPort: 8080
			name:       "client"
		}]
		selector: {
			app:    "updater"
			domain: "prod"
		}
	}
}
deployment: updater: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "updater"
	spec: {
		replicas: 1
		template: {
			metadata: labels: {
				app:       "updater" // TODO: fix updater
				domain:    "prod"
				component: "infra"
			}
			spec: {
				volumes: [{
					name: "secret-updater"
					secret: secretName: "updater-secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/updater:v0.1.0"
					volumeMounts: [{
						mountPath: "/etc/certs"
						name:      "secret-updater"
					}]
					ports: [{
						containerPort: 8080
					}]
					name: "updater"
					args: [
						"-key=/etc/certs/updater.pem",
					]
				}]
			}
		}
	}
}
