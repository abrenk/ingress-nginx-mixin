{
  values+:: {
    grafana+: {
      dashboards+: $.ingressNginx.grafanaDashboards,
    },
    prometheus+: {
      namespaces+: [ $.ingressNginx._config.namespace ]
    },
  },
  ingressNginx:: (import 'kube-prometheus/lib/mixin.libsonnet')({
    name: 'ingress-nginx',
    namespace: 'ingress-nginx',
    labels: {
      'app.kubernetes.io/name': 'ingress-nginx',
      'app.kubernetes.io/component': 'controller',
    },
    mixin: (import 'mixin.libsonnet'),
  }),
}
