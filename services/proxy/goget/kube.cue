package kube

deployment: goget: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name: "goget"
	spec: {
		replicas: 1
		// podTemplate defines the 'cookie cutter' used for creating
		// new pods when necessary
		template: {
			metadata: labels: {
				// Important: these labels need to match the selector above
				// The api server enforces this constraint.
				app:       "goget"
				component: "proxy"
			}
			spec: {
				volumes: [{
					name: "secret-volume"
					secret: secretName: "goget-secrets"
				}]
				containers: [{
					image: "gcr.io/myproj/goget:v0.5.1"
					ports: [{
						containerPort: 7443
					}]
					name: "goget"
					volumeMounts: [{
						mountPath: "/etc/ssl"
						name:      "secret-volume"
					}]
				}]
			}
		}
	}
}
