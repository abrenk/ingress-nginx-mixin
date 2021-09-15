SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

all: prometheus_alerts.yaml prometheus_rules.yaml dashboards_out/nginx.json dashboards_out/request-handling-performance.json

clean:
	@rm -v dashboards_out/*
	@rmdir dashboards_out
	@rm -v prometheus_alerts.yaml
	@rm -v prometheus_rules.yaml

#dashboards/nginx.json:
#	@mkdir -p $(@D)
#	curl -sSo $@ https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/grafana/dashboards/nginx.json

#dashboards/request-handling-performance.json:
#	@mkdir -p $(@D)
#	curl -sSo $@ https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/grafana/dashboards/request-handling-performance.json

manifests: mixin.libsonnet dashboards.jsonnet dashboards/*.libsonnet
	@mkdir -p manifests
	jsonnet -m manifests lib/dashboards.jsonnet

prometheus_alerts.yaml: mixin.libsonnet alerts/* ## Generate Prometheus alerts YAML
	jsonnet -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' -S -o $@

prometheus_rules.yaml: mixin.libsonnet rules/* ## Generate Prometheus rules YAML
	jsonnet -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' -S -o $@

dashboards_out/%.json: mixin.libsonnet dashboards/*.json ## Generate dashboards JSON
	@mkdir -p $(@D)
	jsonnet -e '(import "mixin.libsonnet").grafanaDashboards' -m $(@D) > /dev/null

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean all help
