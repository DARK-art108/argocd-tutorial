.PHONY: install-argocd argocd-password proxy-argocd-ui argocd-status

install-argocd:
	kubectl create ns argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd-password:
	kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | (base64 -d && echo)

proxy-argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8080:443 &

argo-cd-status:
	kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

bootstrap:
	kubectl apply -f resources/application-bootstrap.yaml -n argocd