package kube

service: waiter: {
	spec: {
		ports: [{
			port:       7080
			targetPort: 7080
		}]
	}
}
deployment: waiter: {
	spec: {
		replicas: 5
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/waiter:v0.3.0"
				ports: [{
					containerPort: 7080
				}]
			}]
		}
	}
}
