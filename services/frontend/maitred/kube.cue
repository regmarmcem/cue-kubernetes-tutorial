package kube

service: maitred: {
	spec: {
		ports: [{
			port:       7080
			targetPort: 7080
		}]
	}
}
deployment: maitred: {
	spec: {
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/maitred:v0.0.4"
				ports: [{
					containerPort: 7080
				}]
				args: [
				]
			}]
		}
	}
}
