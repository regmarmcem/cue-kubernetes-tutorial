package kube

service: bartender: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "bartender"
		labels: {
			app:       "bartender"
			domain:    "prod"
			component: "frontend"
		}
	}
	spec: {
		ports: [{
			port:       7080
			protocol:   "TCP"
			targetPort: 7080
			name:       "client"
		}]
		selector: {
			app:       "bartender"
			domain:    "prod"
			component: "frontend"
		}
	}
}
deployment: bartender: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "bartender"
	spec: {
		replicas: 1
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
				labels: {
					app:       "bartender"
					domain:    "prod"
					component: "frontend"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/bartender:v0.1.34"
				ports: [{
					containerPort: 7080
				}]
				name: "bartender"
				args: [
				]
			}]
		}
	}
}
