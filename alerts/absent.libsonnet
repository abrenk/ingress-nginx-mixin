{
  prometheusAlerts+:: {
    groups+: [{
      name: 'ingress-nginx',
      rules: [
        {
          local alert = 'IngressNginxControllerAbsent',
          alert: alert,
          // TODO expr: 'absent(up{job="%(certManagerJobLabel)s"})' % $._config,
          expr: 'absent(up{job="ingress-nginx"})',
          'for': '10m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'NGINX Ingress Controller has disappeared from Prometheus service discovery.',
            description: 'TODO'
            //runbook_url: $._config.certManagerRunbookURLPattern % std.asciiLower(alert),
          },
        },
      ],
    }],
  },
}
