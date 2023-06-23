# Open-telemetry observability

Sample configuration for Kbot that send logs to [OpenTelemetry Collector] and metrics to [OpenTelemetry Collector] or [Prometheus].

[![demo](./grafana.gif)]()

## Prerequisites

- [Docker]
- [Docker Compose]

## How to run

```bash
export TELE_TOKEN=<TOKEN>
docker-compose up
```

Open Grafana in the browser on port 3002
