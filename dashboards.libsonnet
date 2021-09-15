{
  grafanaDashboards+:: {
    'ingress-nginx-overview.json': (import 'dashboards/nginx.json') + {
      title: 'NGINX Ingress Controller / Overview',
      tags: [ 'ingress-nginx-mixin' ],
      uid: std.md5('ingress-nginx-overview.json'),
    },
    'ingress-nginx-request-handling-performance.json': (import 'dashboards/request-handling-performance.json') + {
      title: 'NGINX Ingress Controller / Request Handling Performance',
      tags: [ 'ingress-nginx-mixin' ],
      uid: std.md5('ingress-nginx-request-handline-performance.json'),
    },
  },
}
