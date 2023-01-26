package kube

service: [ID=_]: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name: ID
		labels: {
			app:       ID
			domain:    "prod"
			component: #Component
		}
	}
	spec: {
		ports: [...{
			port:     int
			protocol: *"TCP" | "UDP"
			name:     string | *"client"
		}]
		selector: metadata.labels
	}
}
deployment: [ID=_]: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: ID
	spec: {
		replicas: *1 | int
		template: {
			metadata: labels: {
				app:       ID
				domain:    "prod"
				component: #Component
			}
			spec: containers: [{name: ID}]
		}
	}
}

#Component: string