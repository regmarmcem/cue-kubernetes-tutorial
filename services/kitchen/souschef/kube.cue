package kube

service: souschef: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
		}]
	}
}
deployment: souschef: {
	spec: {
		template: {
			spec: containers: [{
				image: "gcr.io/myproj/souschef:v0.5.3"
				ports: [{
					containerPort: 8080
				}]
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
