package kube

service: souschef: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "souschef"
		labels: {
			app:       "souschef"
			domain:    "prod"
			component: "kitchen"
		}
	}
	spec: {
		ports: [{
			port:       8080
			protocol:   "TCP"
			targetPort: 8080
			name:       "client"
		}]
		selector: app: "souschef"
	}
}
deployment: souschef: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "souschef"
	spec: {
		replicas: 1
		template: {
			metadata: labels: {
				app:       "souschef"
				domain:    "prod"
				component: "kitchen"
			}
			spec: containers: [{
				image: "gcr.io/myproj/souschef:v0.5.3"
				ports: [{
					containerPort: 8080
				}]
				name: "souschef"
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
