package kube

service: bartender: {
	spec: {
		ports: [{
			port:       7080
			targetPort: 7080
		}]
	}
}
deployment: bartender: {
	spec: {
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/bartender:v0.1.34"
				ports: [{
					containerPort: 7080
				}]
				args: [
				]
			}]
		}
	}
}
