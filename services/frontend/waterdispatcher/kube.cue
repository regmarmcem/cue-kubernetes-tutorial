package kube

service: waterdispatcher: {
	spec: {
		ports: [{
			port:       7080
			targetPort: 7080
			name:       "http"
		}]
	}
}
deployment: waterdispatcher: {
	spec: {
		template: {
			metadata: {
				annotations: {
					"prometheus.io.scrape": "true"
					"prometheus.io.port":   "7080"
				}
			}
			spec: containers: [{
				image: "gcr.io/myproj/waterdispatcher:v0.0.48"
				ports: [{
					containerPort: 7080
				}]
				args: [
					"-http=:8080",
					"-etcd=etcd:2379",
				]
			}]
		}
	}
}
