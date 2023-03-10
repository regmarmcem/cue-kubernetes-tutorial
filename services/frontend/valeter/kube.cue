package kube

service: valeter: {
	spec: {
		ports: [{
			port:       8080
			targetPort: 8080
			name:       "http"
		}]
	}
}
deployment: valeter: {
	spec: {
		template: {
			metadata: {
				annotations: "prometheus.io.scrape": "true"
			}
			spec: containers: [{
				image: "gcr.io/myproj/valeter:v0.0.4"
				ports: [{
					containerPort: 8080
				}]
				args: [
					"-http=:8080",
					"-etcd=etcd:2379",
				]
			}]
		}
	}
}
