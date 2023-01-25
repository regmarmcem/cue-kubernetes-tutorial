package kube

service: host: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: "host"
		labels: {
			app:       "host"
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
			app:       "host"
			domain:    "prod"
			component: "frontend"
		}
	}
}
deployment: host: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "host"
	spec: {
		replicas: 2
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
				labels: {
					app:       "host"
					domain:    "prod"
					component: "frontend"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/host:v0.1.10"
				ports: [{
					containerPort: 7080
				}]
				name: "host"
				args: [
				]
			}]
		}
	}
}
